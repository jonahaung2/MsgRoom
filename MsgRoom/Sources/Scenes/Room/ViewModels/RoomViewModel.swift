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
import Models
import Database
import Core

@MainActor
public class RoomViewModel: ObservableObject {
    
    let datasource: RoomDatasource
    var roomState = RoomStates()
    let interactor: MsgInteractions
    private let locak = RecursiveLock()
    private let viewUpdates = PassthroughSubject<AnyHashable, Never>()
    @Published var viewChanges = false
    private let cancelBag = CancelBag()
    
    init(_ dataProvider: any MsgDatasource, _ interation: MsgInteractions) {
        datasource = .init(dataProvider)
        interactor = interation
        viewUpdates
            .removeDuplicates()
            .debounce(for: 0.3, scheduler: RunLoop.main)
            .sink { [weak self] value in
                guard let self else { return }
                self.viewChanges.toggle()
            }
            .store(in: cancelBag)
        datasource
            .$updater
            .removeDuplicates()
            .debounce(for: 0.1, scheduler: RunLoop.main)
            .sink {[weak self] value in
                guard let self = self else { return }
                queueForUpdate()
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
        locak.sync {
            self.roomState.scrollItem = ScrollItem(id: datasource.msgStyles.first?.msg.id ?? "0", anchor: .top, animate: animated)
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
                    self.viewChanges.toggle()
                }
            }
        case .atBottom:
            locak.sync {
                self.roomState.showScrollToLatestButton = false
                self.roomState.focusId = nil
                self.roomState.selectedId = nil
                self.datasource.reset()
            }
        case .nearBottom:
            if !roomState.showScrollToLatestButton {
                locak.sync {
                    roomState.showScrollToLatestButton = true
                    queueForUpdate()
                }
            }
        default:
            break
        }
    }
    func queueForUpdate() {
        viewUpdates.send(Int.random(in: 0...30))
    }
}
