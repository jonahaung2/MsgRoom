//
//  ChatDatasource.swift
//  Msgr
//
//  Created by Aung Ko Min on 27/10/22.
//

import SwiftUI
import XUI
import Combine

final class ChatDatasource<MsgItem: MessageRepresentable, ConItem: ConversationRepresentable>: ChatDatasoureceRepresentable {
    
    @Published var updater = 0
    
    let pageSize = 50
    var currentPage = 1
    var con: ConItem
    var allMsgs = [MsgItem]()
    private var cancellables = Set<AnyCancellable>()
    
    init(_ con: ConItem) {
        self.con = con
        self.allMsgs = con.msgs()
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
    }
    var msgs: ArraySlice<MsgItem> {
        allMsgs.prefix(pageSize*currentPage)
    }
    var enuMsgs: Array<(offset: Int, element: MsgItem)> {
        Array(msgs.enumerated())
    }
    
    @MainActor func loadMoreIfNeeded() -> Bool {
        guard currentPage*pageSize <= allMsgs.count else {
            return false
        }
        currentPage += 1
        return true
    }
    @MainActor private func didRecieveNoti(_ noti: MsgNoti) {
        switch noti.type {
        case .New(let payload):
            allMsgs.insert(payload as! MsgItem, at: 0)
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
}
