//
//  MsgRoomViewModel.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 1/4/24.
//

import SwiftUI
import Combine
import XUI

class ChatViewUpdates: ObservableObject {

    typealias Work = () -> Void

    @Published var blockOperations = [Work]()

    func insert(_ block: @escaping Work) {
        blockOperations.append(block)
    }

    func handleUpdates() {
        blockOperations.forEach { $0() }
        blockOperations.removeAll()
    }
}

class MsgRoomViewModel<Msg: MsgKind, Con: ConKind>: ChatViewModelImplementation {
    var selectedMsg: Msg?
    var quotedMsg: Msg?
    @Published var con: Con
    @Published var scrollItem: ScrollItem = .init(id: 1, anchor: .bottom)
    @Published var selectedId: String?
    @Published var focusedId: String?
    @Published var showScrollToLatestButton = false
    @Published var isTyping = false
    private let chatViewUpdates = ChatViewUpdates()
    
    var markedMsgDisplayInfo: MsgDisplayInfo?
    let msgStyleWorker: MsgStyleStylingWorker<Msg, Con>
    
    var datasource: ChatDatasource<Msg, Con>
    private var cancellables = Set<AnyCancellable>()
    
    required init(con: Con) {
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
// Update
extension MsgRoomViewModel {
    func queueForUpdate(block: (@escaping () -> Void) = {}) {
        chatViewUpdates.insert(block)
    }
}

// Actions
extension MsgRoomViewModel {

    func setMarkedMsg(_ info: MsgDisplayInfo?) {
        _Haptics.play(.light)
        markedMsgDisplayInfo = info
        queueForUpdate()
    }

    func setSelectedMsg(_ msg: Msg?) {
        _Haptics.play(.light)
        selectedMsg = selectedMsg == msg ? nil : msg
        queueForUpdate()
    }
    func setQuoteddMsg(_ msg: Msg?) {
        _Haptics.play(.light)
        quotedMsg = msg
        queueForUpdate()
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
            self.datasource.loadMoreIfNeeded {
                self.objectWillChange.send()
            }
        }
    }
}

