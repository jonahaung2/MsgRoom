//
//  ChatDatasource.swift
//  Msgr
//
//  Created by Aung Ko Min on 27/10/22.
//

import SwiftUI
import XUI
import Combine

final class ChatDatasource<MsgItem: Msgable, ConItem: Conversationable>: MsgRoomDatasourceRepresentable {
    
    let pageSize = 50
    var currentPage = 1
    @Published var con: ConItem
    @Published var allMsgs = [MsgItem]()
    private var cancellables = Set<AnyCancellable>()
    
    init(_ con: ConItem) {
        self.con = con
        self.allMsgs = con.msgs()
        NotificationCenter.default
            .publisher(for: .msgNoti(for: con.id))
            .compactMap{ $0.msgNoti }
            .receive(on: RunLoop.main)
            .sink { [weak self] value in
                guard let self = self else { return }
                self.didRecieveNoti(value)
            }
            .store(in: &cancellables)
    }
    var msgs: ArraySlice<MsgItem> {
        allMsgs.prefix(pageSize*currentPage)
    }
    var enuMsgs: Array<(offset: Int, element: MsgItem)> {
        Array(msgs.enumerated())
    }
    func loadMoreIfNeeded() -> Bool {
        guard currentPage*pageSize <= allMsgs.count else {
            return false
        }
        currentPage += 1
        return true
    }
    func update() {}
    private func didRecieveNoti(_ noti: MsgNoti) {
        switch noti.type {
        case .New(let payload):
            allMsgs.insert(payload as! MsgItem, at: 0)
        default:
            break
        }
    }
}
