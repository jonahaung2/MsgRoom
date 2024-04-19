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
    
    @Published var scrollItem: ScrollItem?
    @Published var selectedId: String?
    @Published var focusedId: String?
    @Published var showScrollToLatestButton = false
    
    let msgStyleWorker: MsgStyleStylingWorker
    private let chatViewUpdates = ViewUpdater()
    let datasource: ChatDatasource<Msg>
    private var cancellables = Set<AnyCancellable>()
    
    init(datasource: ChatDatasource<Msg>) {
        self.datasource = datasource
        msgStyleWorker = .init(datasource.con)
        datasource
            .$updater
            .removeDuplicates()
            .receive(on: RunLoop.main)
            .sink {[weak self] value in
                guard let self = self else { return }
                self.queueForUpdate()
            }
            .store(in: &cancellables)
        chatViewUpdates
            .$blockOperations
            .debounce(for: 0.3, scheduler: RunLoop.main)
            .sink { [weak self] value in
                guard let self else { return }
                if value.count > 0 {
                    self.chatViewUpdates.handleUpdates()
                } else {
                    withAnimation(.interactiveSpring) {
                        self.objectWillChange.send()
                    }
                }
            }
            .store(in: &cancellables)
    }
    deinit {
        Log("deinit")
    }
}

extension MsgRoomViewModel {
    @MainActor func scrollToBottom(_ animated: Bool) {
        scrollItem = ScrollItem(id: 1, anchor: .top, animate: animated)
        datasource.update()
    }
    @MainActor func didUpdateVisibleRect(_ visibleRect: CGRect) {
        let scrollButtonShown = visibleRect.minY < 0
        if scrollButtonShown != showScrollToLatestButton {
            withAnimation {
                showScrollToLatestButton = scrollButtonShown
            }
        }
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

