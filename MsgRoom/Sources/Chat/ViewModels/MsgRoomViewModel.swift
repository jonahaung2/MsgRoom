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
class MsgRoomViewModel<Msg: MessageRepresentable, Con: ConversationRepresentable>: ObservableObject {
    
    @Published var change = 0
    let datasource: ChatDatasource<Msg, Con>
    let settings = MsgRoomSettings()
    
    let msgStyleWorker: MsgStyleStylingWorker<Msg, Con>
    private let chatViewUpdates = ViewUpdater()
    
    private var cancellables = CancelBag()
    
    init(_ con: Con) {
        self.datasource = .init(con)
        msgStyleWorker = .init(con)
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
            .store(in: cancellables)
        datasource
            .$updater
            .removeDuplicates()
            .debounce(for: 0.1, scheduler: RunLoop.main)
            .sink {[weak self] value in
                guard let self = self else { return }
                self.queueForUpdate()
            }
            .store(in: cancellables)
        settings
            .objectWillChange
            .debounce(for: 0.2, scheduler: RunLoop.main)
            .sink {[weak self] _ in
                guard let self = self else { return }
                self.queueForUpdate()
            }
            .store(in: cancellables)
        NotificationCenter.default
            .publisher(for: .init(con.id))
            .removeDuplicates()
            .receive(on: RunLoop.main)
            .compactMap{ $0.object as? AnyMsgData }
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
            .store(in: cancellables)
    }
    deinit {
        Log("deinit")
    }
}

extension MsgRoomViewModel {
    @MainActor func scrollToBottom(_ animated: Bool) {
        if let id = self.datasource.msgs.first?.id {
            if settings.scrollItem?.id == id {
                settings.scrollItem = nil
            }
            settings.scrollItem = ScrollItem(id: id, anchor: .top, animate: animated)
            objectWillChange.send()
            datasource.currentPage = 1
        }
    }
    @MainActor func didUpdateVisibleRect(_ visibleRect: CGRect) {
        queueForUpdate { [weak self] in
            guard let self else { return }
            self.settings.showScrollToLatestButton = visibleRect.height != visibleRect.maxY
        }
        let nearTop = visibleRect.maxY < UIScreen.main.bounds.height
        if nearTop {
            if self.datasource.loadMoreIfNeeded() {
                change += 1
            }
        }
    }
    func queueForUpdate(block: (@escaping () -> Void) = {}) {
        chatViewUpdates.insert(block)
    }
}
