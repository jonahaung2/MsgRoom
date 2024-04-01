//
//  ChatDatasource.swift
//  Msgr
//
//  Created by Aung Ko Min on 27/10/22.
//

import SwiftUI
import XUI

final class ChatDatasource<MsgItem: Msgable>: MsgRoomDatasourceRepresentable {

    internal let pageSize = 50
    internal var currentPage = 1
    internal let conId: String
    @Published var allMsgs = [MsgItem]()

    init(conId: String) {
        self.conId = conId
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
    
    func update() {
        
    }
}
