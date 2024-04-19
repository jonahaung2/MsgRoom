//
//  ChatDatasource.swift
//  Msgr
//
//  Created by Aung Ko Min on 27/10/22.
//

import SwiftUI
import XUI
import Combine

final class MsgRoomDatasource<Msg: MessageRepresentable>: ObservableObject {
    
    @Published var updater = 0
    let pageSize = 50
    var currentPage = 1
    var con: any ConversationRepresentable
    var allMsgs = [Msg]()
    
    var blocks = [MsgPair]()
    var allMsgsCount = 0
    var isFetching = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init(_ con: any ConversationRepresentable) {
        self.con = con
        self.allMsgs = con.msgs()
        self.allMsgsCount = self.allMsgs.count
        NotificationCenter.default
            .publisher(for: .msgNoti(for: con.id))
            .removeDuplicates()
            .receive(on: RunLoop.current)
            .compactMap{ $0.msgNoti }
            .sink(receiveValue: { [weak self] value in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.didRecieveNoti(value)
                }
            })
            .store(in: &cancellables)
        fetch()
    }
    var msgs: ArraySlice<Msg> {
        allMsgs.prefix(pageSize*currentPage)
    }
    var enuMsgs: Array<(offset: Int, element: Msg)> {
        Array(msgs.enumerated())
    }
    
    
    @MainActor func loadMoreIfNeeded(_ block: (() -> Void)? = nil) {
        guard !isFetching && allMsgsCount > pageSize && currentPage*pageSize <= allMsgsCount else {
            return
        }
        isFetching = true
        currentPage += 1
        fetch(block)
//        guard currentPage*pageSize <= allMsgs.count else {
//            return false
//        }
//        currentPage += 1
//        return true
    }
    @MainActor private func didRecieveNoti(_ noti: MsgNoti) {
        switch noti.type {
        case .New(let payload):
            allMsgs.insert(payload as! Msg, at: 0)
            update()
            Audio.playMessageOutgoing()
        case .Update(let item):
            update()
        default:
            break
        }
    }
    @MainActor func update() {
        updater += 1
    }
    private func generateItems(_ block: (() -> Void)? = nil) {
        blocks = allMsgs.withPreviousAndNext
        isFetching = false
        block?()
    }
    func reset(_ block: (() -> Void)? = nil ) {
        guard currentPage > 2 else {
            block?()
            return
        }
        currentPage = 2
        fetch(block)
    }
}
extension Sequence {
    var withPreviousAndNext: [(Element?, Element, Element?)] {
        let optionalSelf = self.map(Optional.some)
        let next = optionalSelf.dropFirst() + [nil]
        let prev = [nil] + optionalSelf.dropLast()
        return zip(self, zip(prev, next)).map {
            ($1.0, $0, $1.1)
        }
    }
}
