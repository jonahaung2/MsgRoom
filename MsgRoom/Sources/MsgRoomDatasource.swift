//
//  ChatDatasource.swift
//  Msgr
//
//  Created by Aung Ko Min on 27/10/22.
//

import SwiftUI
import XUI
import Combine
import MsgrCore

final class ChatDatasource<MsgItem: MessageRepresentable>: ObservableObject {
    
    @Published var updater = 0
    let pageSize = 50
    var currentPage = 1
    var con: any ConversationRepresentable
    var allMsgs = [MsgItem]()
    private var cancellables = Set<AnyCancellable>()
    
    init(_ con: any ConversationRepresentable) {
        self.con = con
        self.allMsgs = con.msgs()
        NotificationCenter.default
            .publisher(for: .init(con.id))
            .removeDuplicates()
            .receive(on: RunLoop.current)
            .compactMap{ $0.incomingData }
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
    @MainActor private func didRecieveNoti(_ data: IncomingData) {
        switch data {
        case .newMsg(let msg):
            Audio.playMessageIncoming()
            insertMsg(msg as! MsgItem)
        case .updateMsg(let item):
            if let found = msgs.first(where: { msg in
                msg.id == item.id
            }) {
                found.deliveryStatus = item.deliveryStatus
                update()
            }
        case .typing(let conID, let uids):
            break
        }
    }
    @MainActor func insertMsg(_ msg: MsgItem) {
        allMsgs.insert(msg, at: 0)
        update()
    }
    @MainActor func update() {
        updater += 1
    }
}
