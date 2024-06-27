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
class MsgRoomViewModel<Msg: Msg_, Con: Conversation_>: ObservableObject {
    
    @Published var change = 0
    let datasource: ChatDatasource<Msg, Con>
    let settings = MsgRoomSettings()
    private let chatViewUpdates = ViewUpdater()
    
    private let cancelBag = CancelBag()
    
    init(_ con: Con) {
        self.datasource = .init(con)
        chatViewUpdates
            .$blockOperations
            .debounce(for: 0.1, scheduler: RunLoop.main)
            .sink { [weak self] value in
                guard let self else { return }
                if value.count > 0 {
                    self.chatViewUpdates.handleUpdates()
                } else {
                    self.change += 1
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
                self.datasource.checkSelectedId(id: self.settings.selectedId)
                self.datasource.checkFocusId(id: self.settings.focusedId)
            }
            .store(in: cancelBag)
        NotificationCenter.default
            .publisher(for: .msgNoti(for: con.id))
            .removeDuplicates()
            .receive(on: RunLoop.main)
            .compactMap{ $0.anyMsgData }
            .asyncSink(receiveValue: { [weak self] data in
                guard let self else { return }
                if self.settings.showScrollToLatestButton == true {
                    await self.scrollToBottom(false)
                    try? await Task.sleep(seconds: 0.2)
                    await self.datasource.didRecieveNoti(data)
                } else {
                    await self.datasource.didRecieveNoti(data)
                    await self.queueForUpdate()
                }
            })
            .store(in: cancelBag)
    }
    deinit {
        Log("deinit")
    }
}

extension MsgRoomViewModel {
    @MainActor func scrollToBottom(_ animated: Bool) {
        if let id = self.datasource.msgStyles.first?.msg.id {
            if settings.scrollItem?.id == id {
                settings.scrollItem = nil
            }
            settings.scrollItem = ScrollItem(id: id, anchor: .top, animate: animated)
            objectWillChange.send()
            datasource.reset()
        }
    }
    @MainActor func didUpdateVisibleRect(_ visibleRect: CGRect) {
        let nearTop = visibleRect.maxY < UIScreen.main.bounds.height
        let atBottom = (visibleRect.height - abs(visibleRect.maxY)) == 0
        if atBottom {
            self.settings.showScrollToLatestButton = false
            datasource.reset()
        } else if nearTop {
            if self.datasource.loadMoreIfNeeded() {
                change += 1
            }
        } else {
            if !self.settings.showScrollToLatestButton {
                self.settings.showScrollToLatestButton = true
            }
        }
    }
    func queueForUpdate(block: (@escaping () -> Void) = {}) {
        chatViewUpdates.insert(block)
    }
}
