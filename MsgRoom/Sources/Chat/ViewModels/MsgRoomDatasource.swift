//
//  ChatDatasource.swift
//  Msgr
//
//  Created by Aung Ko Min on 27/10/22.
//

import SwiftUI
import XUI
import SwiftData

final class ChatDatasource<Msg: Msg_, ConItem: Conversation_>: ObservableObject {
    
    typealias MsgStyle = (msg: Msg, style: MsgDecoration)
    @Published var updater = 0
    private let msgStyleWorker = MsgStyleStylingWorker()
    private var selectedId: String?
    private var focusId: String?
    var msgStyles = [MsgStyle]()
    
    private let pageSize = 50
    private var currentPage = 1
    var con: ConItem
    var allMsgs = [Msg]()
    
    init(_ con: ConItem) {
        self.con = con
    }
    
    func loadMoreIfNeeded() -> Bool {
        guard currentPage*pageSize <= allMsgs.count else {
            return false
        }
        currentPage += 1
        updateData()
        return true
    }
    func fetch() async {
//        allMsgs = (try? await con.fetchMsgs()) ?? []
    }
     func updateData() {
        var results = [MsgStyle]()
        let msgs = allMsgs.prefix(pageSize*currentPage)
        let enuMsgs =  Array(msgs.enumerated())
        enuMsgs.forEach { (i, msg) in
            let style = msgStyleWorker.msgStyle(
                for: msg, 
                for: con,
                at: i,
                selectedId: selectedId,
                focusedId: focusId,
                msgs: Array(msgs)
            )
            let msgStyle = MsgStyle(msg, style)
            results.append(msgStyle)
        }
        self.msgStyles = results
        update()
    }
    func didRecieveNoti(_ data: AnyMsgData) async {
        switch data {
        case .newMsg(let msg):
            allMsgs.insert(msg as! Msg, at: 0)
            updateData()
        case .updatedMsg(let msg):
            if let thisMsg = msg as? Msg, let i = allMsgs.firstIndex(of: thisMsg) {
                allMsgs.remove(at: i)
                allMsgs.insert(thisMsg, at: i)
                update()
            }
        case .typingStatus(let typingStatus):
            Log(typingStatus)
        }
    }
    func update() {
        updater += 1
    }
    
    func reset() {
        guard currentPage > 1 else { return }
        currentPage = 1
        updateData()
        print("reset")
    }
    func checkSelectedId(id: String?) {
        guard selectedId != id else { return }
        self.selectedId = id
        updateData()
    }
    func checkFocusId(id: String?) {
        guard focusId != id else { return }
        self.focusId = id
        updateData()
    }
}
