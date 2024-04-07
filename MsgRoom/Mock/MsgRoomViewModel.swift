//
//  MsgRoomViewModel.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 1/4/24.
//

import SwiftUI
import Combine
import XUI

class MsgRoomViewModel<MsgItem: MessageRepresentable, ConItem: ConversationRepresentable>: ChatViewModelImplementation {
    
    @Published var con: ConItem
    @Published var scrollItem: ScrollItem?
    @Published var selectedId: String?
    @Published var focusedId: String?
    @Published var showScrollToLatestButton = false
    @Published var isTyping = false
    let msgStyleWorker: MsgStyleStylingWorker<MsgItem, ConItem>
    
    var datasource: ChatDatasource<MsgItem, ConItem>
    private var cancellables = Set<AnyCancellable>()
    
    required init(con: ConItem) {
        self.con = con
        datasource = .init(con)
        msgStyleWorker = .init(con)
        datasource
            .$updater
            .removeDuplicates()
            .throttle(for: 0.5, scheduler: RunLoop.main, latest: true)
            .sink {[weak self] value in
                guard let self = self else { return }
                withAnimation(.interactiveSpring) {
                    self.objectWillChange.send()
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
}

