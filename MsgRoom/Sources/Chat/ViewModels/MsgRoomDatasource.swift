//
//  ChatDatasource.swift
//  Msgr
//
//  Created by Aung Ko Min on 27/10/22.
//

import SwiftUI
import XUI
import MsgRoomCore

final class ChatDatasource<Msg: MsgRepresentable, RoomItem: RoomRepresentable, Contact: ContactRepresentable>: ObservableObject {
    
    typealias MsgStyle = (msg: Msg, style: MsgCellPresenter)
    
    @Published var updater = 0
    
    private let msgStyleWorker = MsgStyleStylingWorker()
    var msgStyles = [MsgStyle]()
    
    private let pageSize = 50
    private var currentPage = 1
    var room: RoomItem
    private var allMsgs = [Msg]()
    var selectedId: String?
    private var focusId: String?
    
    init(_ room: RoomItem) {
        self.room = room
        allMsgs = room.msgs()
        updateData()
    }
    
    func loadMoreIfNeeded() -> Bool {
        guard currentPage*pageSize <= allMsgs.count else {
            return false
        }
        currentPage += 1
        updateData()
        return true
    }
    
    func updateData() {
        var results = [MsgStyle]()
        let msgs = allMsgs.prefix(pageSize*currentPage)
        msgs.enumerated().forEach { (i, msg) in
            let style = msgStyleWorker.msgStyle(
                for: msg,
                at: i,
                selectedId: selectedId,
                focusedId: focusId,
                msgs: allMsgs
            )
            let msgStyle = MsgStyle(msg, style)
            results.append(msgStyle)
        }
        self.msgStyles = results
        update()
    }
    @MainActor
    func didRecieveNoti(_ data: AnyMsgData) {
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
    
    func checkSelectedId(id: String) {
        if focusId != nil {
            focusId = nil
            updateData()
            return
        }
        selectedId = selectedId == id ? nil : id
        updateData()
    }
    
    func checkFocusId(id: String?) {
        guard focusId != id else { return }
        self.focusId = id
        updateData()
    }
    
    func updateLastMsg() {
        if let msg = allMsgs.first {
            let sender: Contact? = msg.sender()
            room.lastMsg = .init(msg: msg, sender: sender)
        }
    }
    
    deinit {
        Log("deinit")
    }
}
