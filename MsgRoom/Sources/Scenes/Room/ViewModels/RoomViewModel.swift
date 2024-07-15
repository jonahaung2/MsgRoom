//
//  MsgRoomViewModel.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 1/4/24.
//

import SwiftUI
import Combine
import XUI
import AsyncQueue

@MainActor
public class RoomViewModel: ObservableObject {

    let datasource: RoomDatasource
    var roomState = RoomStates()
    let interactor: MsgInteractionProviding
    private let locak = RecursiveLock()
    
    @Published var viewChanges = 0
    private let blockUpdater = BlockUpdater()
    private let cancelBag = CancelBag()
    
    init(_ dataProvider: any MsgDatasourceProviding, _ interation: MsgInteractionProviding) {
        datasource = .init(dataProvider)
        interactor = interation
        blockUpdater
            .$blockOperations
            .debounce(for: 0.2, scheduler: RunLoop.main)
            .sink { [weak self] value in
                guard let self else { return }
                if value.count > 0 {
                    self.blockUpdater.handleUpdates()
                } else {
                    self.viewChanges += 1
                }
            }
            .store(in: cancelBag)
        datasource
            .$updater
            .removeDuplicates()
            .debounce(for: 0.1, scheduler: RunLoop.main)
            .sink {[weak self] value in
                guard let self = self else { return }
                self.queueForUpdate()
            }
            .store(in: cancelBag)
        NotificationCenter.default
            .publisher(for: .msgNoti(for: interactor.room.id))
            .removeDuplicates()
            .receive(on: RunLoop.current)
            .compactMap{ $0.anyMsgData }
            .asyncSink(receiveValue: { [weak self] data in
                guard let self else { return }
                await self.scrollToBottom(false)
                await datasource.didRecieveNoti(data)
            })
            .store(in: cancelBag)
    }
    
    deinit {
        Log("deinit")
    }
    private var cachedOffset = InversedOffset.none
    func setSelectedMsg(_ id: String) {
        locak.sync {
            roomState.selectedId = roomState.selectedId == id ? nil : id
            datasource.updateData(roomState)
        }
    }
    func setFocusedMsg(_ id: String) {
        locak.sync {
            roomState.focusId = roomState.focusId == id ? nil : id
            datasource.updateData(roomState)
        }
    }
}

extension RoomViewModel {
    @MainActor func scrollToBottom(_ animated: Bool) {
        MainActorQueue.shared.enqueue {
            self.roomState.scrollItem = ScrollItem(id: "0", anchor: .top, animate: animated)
            self.datasource.reset()
            self.objectWillChange.send()
        }
    }
    
    @MainActor func didUpdateDynamicOffset(_ dyOfffset: InversedOffset) {
        guard cachedOffset != dyOfffset else { return }
        cachedOffset = dyOfffset
        switch dyOfffset {
        case .nearTop:
            locak.sync {
                if datasource.loadMoreIfNeeded(roomState) {
                    MainActorQueue.shared.enqueue {
                        self.viewChanges += 1
                    }
                    MainActorQueue.shared.enqueue {
                        self.cachedOffset = .nearBottom
                    }
                }
            }
        case .atBottom:
            MainActorQueue.shared.enqueue {
                self.roomState.showScrollToLatestButton = false
                self.roomState.focusId = nil
                self.roomState.selectedId = nil
                self.datasource.reset()
            }
        case .nearBottom:
            roomState.showScrollToLatestButton = true
            queueForUpdate()
        default:
            break
        }
    }
    func queueForUpdate(block: (@escaping () -> Void) = {}) {
        blockUpdater.insert(block)
    }
}
