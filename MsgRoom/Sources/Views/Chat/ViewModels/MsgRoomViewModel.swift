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
public class MsgRoomViewModel<Msg: MsgRepresentable, Room: RoomRepresentable, Contact: ContactRepresentable>: ObservableObject {
    
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
                self.datasource.didRecieveNoti(data)
            })
            .store(in: cancelBag)
    }
    
    deinit {
        Log("deinit")
    }
    private var cachedOffset = InversedOffset.none
}

extension MsgRoomViewModel {
    @MainActor func scrollToBottom(_ animated: Bool) {
        self.settings.scrollItem = ScrollItem(id: "0", anchor: .top, animate: animated)
        self.datasource.reset()
        self.objectWillChange.send()
    }

    @MainActor func didUpdateDynamicOffset(_ dyOfffset: InversedOffset) {
        guard cachedOffset != dyOfffset else { return }
        cachedOffset = dyOfffset
        switch dyOfffset {
        case .atTop:
            showScrollToLatestButton = true
            queueForUpdate()
        case .nearTop:
            if datasource.loadMoreIfNeeded() {
                withAnimation(.interactiveSpring) { // Stopped the scrolling for a while
                    viewChanges += 1
                }
                cachedOffset = .nearBottom
            }
        case .center, .nearCenter:
            showScrollToLatestButton = true
            datasource.checkFocusId(id: nil)
            queueForUpdate()
        case .atBottom:
            showScrollToLatestButton = false
            datasource.reset()
            queueForUpdate()
        case .nearBottom:
            showScrollToLatestButton = true
            queueForUpdate()
        case .none:
            break
        }
    }
    func queueForUpdate(block: (@escaping () -> Void) = {}) {
        chatViewUpdates.insert(block)
    }
}
