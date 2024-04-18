//
//  ChatDatasource.swift
//  Msgr
//
//  Created by Aung Ko Min on 27/10/22.
//

import SwiftUI
import XUI
import Combine

final class ChatDatasource<Msg: MsgKind, Con: ConKind>: ChatDatasoureceRepresentable {
    
    typealias MsgPair = (prev: Msg?, msg: Msg, next: Msg?)
    
    @Published var updater = 0

    let pageSize = 50
    var currentPage = 1
    var con: Con
    var allMsgs = [Msg]()
    
    var blocks = [MsgPair]()
    var allMsgsCount = 0
    var isFetching = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init(_ con: Con) {
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
//    var msgs: ArraySlice<MsgItem> {
//        allMsgs.prefix(pageSize*currentPage)
//    }
//    var enuMsgs: Array<(offset: Int, element: MsgItem)> {
//        Array(msgs.enumerated())
//    }
    
    private func fetch(_ block: (() -> Void)? = nil) {
        self.allMsgs = con.msgs()
        generateItems()
        block?()
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
            allMsgs.insert(payload as! MsgItem, at: 0)
            generateItems()
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
