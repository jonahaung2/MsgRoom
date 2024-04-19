//
//  MsgRoomViewModel.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 1/4/24.
//

import SwiftUI
import Combine
import XUI

class MsgRoomViewModel<Msg: MessageRepresentable>: ObservableObject {
    
    let datasource: ChatDatasource<Msg>
    let settings = MsgRoomSettings()
    
    let msgStyleWorker: MsgStyleStylingWorker
    private let chatViewUpdates = ViewUpdater()
    
    private var cancellables = Set<AnyCancellable>()
    
    init(datasource: ChatDatasource<Msg>) {
        self.datasource = datasource
        msgStyleWorker = .init(datasource.con)
        chatViewUpdates
            .$blockOperations
            .debounce(for: 0.1, scheduler: RunLoop.main)
            .sink { [weak self] value in
                guard let self else { return }
                if value.count > 0 {
                    self.chatViewUpdates.handleUpdates()
                } else {
                    self.objectWillChange.send()
                }
            }
            .store(in: &cancellables)
        datasource
            .$updater
            .removeDuplicates()
            .receive(on: RunLoop.main)
            .sink {[weak self] value in
                guard let self = self else { return }
                self.queueForUpdate()
            }
            .store(in: &cancellables)
        settings
            .objectWillChange
            .receive(on: RunLoop.main)
            .sink {[weak self] _ in
                guard let self = self else { return }
                self.queueForUpdate()
            }
            .store(in: &cancellables)
    }
    deinit {
        Log("deinit")
    }
}

extension MsgRoomViewModel {
    @MainActor func scrollToBottom(_ animated: Bool) {
        settings.scrollItem = ScrollItem(id: 1, anchor: .top, animate: animated)
        datasource.update()
    }
    @MainActor func didUpdateVisibleRect(_ visibleRect: CGRect) {
        settings.showScrollToLatestButton = visibleRect.minY < 0
        let nearTop = visibleRect.maxY < UIScreen.main.bounds.height
        if nearTop {
            if self.datasource.loadMoreIfNeeded() {
                self.objectWillChange.send()
            }
        }
    }
    func queueForUpdate(block: (@escaping () -> Void) = {}) {
        chatViewUpdates.insert(block)
    }
}

