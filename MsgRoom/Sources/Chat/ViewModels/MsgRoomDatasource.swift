//
//  ChatDatasource.swift
//  Msgr
//
//  Created by Aung Ko Min on 27/10/22.
//

import SwiftUI
import XUI

final class ChatDatasource<Msg: MessageRepresentable, ConItem: ConversationRepresentable>: ObservableObject {
    
    @Published var updater = 0
    let pageSize = 50
    var currentPage = 1
    var con: ConItem
    var allMsgs = [Msg]()
    
    init(_ con: ConItem) {
        self.con = con
        self.allMsgs = con.msgs()
        
    }
    var msgs: ArraySlice<Msg> {
        allMsgs.prefix(pageSize*currentPage)
    }
    var enuMsgs: Array<(offset: Int, element: Msg)> {
        Array(msgs.enumerated())
    }
    
    func loadMoreIfNeeded() -> Bool {
        guard currentPage*pageSize <= allMsgs.count else {
            return false
        }
        currentPage += 1
        return true
    }
    func didRecieveNoti(_ data: AnyMsgData) async {
        switch data {
        case .newMsg(let msg):
            allMsgs.insert(msg as! Msg, at: 0)
        case .updatedMsg(let msg):
            if let thisMsg = msg as? Msg, let i = allMsgs.firstIndex(of: thisMsg) {
                allMsgs.remove(at: i)
                allMsgs.insert(thisMsg, at: i)
            }
        case .typingStatus(let typingStatus):
            Log(typingStatus)
        }
    }
    func update() {
        updater += 1
    }
}
