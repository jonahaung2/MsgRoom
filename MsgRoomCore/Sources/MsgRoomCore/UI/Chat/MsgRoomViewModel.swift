//
//  MsgRoomViewModel.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 1/4/24.
//

import SwiftUI
import Combine
import XUI


@MainActor
class MsgRoomViewModel<Msg: MsgRepresentable, Room: RoomRepresentable, Contact: ContactRepresentable>: ObservableObject {
    
    @Published var viewChanges = 0
    var showScrollToLatestButton = false
    let datasource: ChatDatasource<Msg, Room, Contact>
    let settings = MsgRoomSettings()
    private let chatViewUpdates = ViewUpdater()
    private let cancelBag = CancelBag()
    
    init(_ room: Room) {
        datasource = .init(room)
        chatViewUpdates
            .$blockOperations
            .debounce(for: 0.1, scheduler: RunLoop.main)
            .sink { [weak self] value in
                guard let self else { return }
                if value.count > 0 {
                    self.chatViewUpdates.handleUpdates()
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
        settings
            .objectWillChange
            .debounce(for: 0.2, scheduler: RunLoop.main)
            .sink {[weak self] _ in
                guard let self = self else { return }
                queueForUpdate()
            }
            .store(in: cancelBag)
        NotificationCenter.default
            .publisher(for: .msgNoti(for: room.id))
            .removeDuplicates()
            .receive(on: RunLoop.main)
            .compactMap{ $0.anyMsgData }
            .asyncSink(receiveValue: { [weak self] data in
                guard let self else { return }
                await self.scrollToBottom(false)
                await self.datasource.didRecieveNoti(data)
            })
            .store(in: cancelBag)
    }
    
    deinit {
        Log("deinit")
    }
}

extension MsgRoomViewModel {
    @MainActor func scrollToBottom(_ animated: Bool) {
        settings.scrollItem = nil
        self.settings.scrollItem = ScrollItem(id: "0", anchor: .top, animate: animated)
        self.objectWillChange.send()
        self.datasource.reset()
    }
    @MainActor func didUpdateVisibleRect(_ rect: CGRect) {
        guard
            rect.maxY != settings.scrollViewFrame.maxY,
            rect.height > 2000
        else { return }
        let nearTop = rect.maxY < 2000
        if nearTop {
            if datasource.loadMoreIfNeeded() {
                withAnimation(.interactiveSpring) {
                    viewChanges += 1
                }
            }
        } else {
            let canShow = rect.minY < -400
            if showScrollToLatestButton != canShow {
                showScrollToLatestButton = canShow
                queueForUpdate()
            }
        }
    }
    func queueForUpdate(block: (@escaping () -> Void) = {}) {
        chatViewUpdates.insert(block)
    }
}
