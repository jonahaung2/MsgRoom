//
//  ChatDatasource.swift
//  Msgr
//
//  Created by Aung Ko Min on 27/10/22.
//

import SwiftUI
import XUI

final class ChatDatasource<Msg: MessageRepresentable, ConItem: ConversationRepresentable>: ObservableObject {
    
    typealias MsgStyle = (msg: Msg, style: MsgDecoration)
    
    @Published var updater = 0
    private let msgStyleWorker: MsgStyleStylingWorker<Msg, ConItem>
    private let lock = RecursiveLock()
    private var selectedId: String?
    private var focusId: String?
    var msgStyles = [MsgStyle]()
    
    private let pageSize = 50
    private var currentPage = 1
    var con: ConItem
    private var allMsgs = [Msg]()
    
    init(_ con: ConItem) {
        self.con = con
        msgStyleWorker = .init(con)
        self.allMsgs = con.msgs()
        updateData()
    }
    
    func loadMoreIfNeeded() -> Bool {
        return lock.sync {
            guard currentPage*pageSize <= allMsgs.count else {
                return false
            }
            currentPage += 1
            updateData()
            return true
        }
    }
    
    private func updateData() {
        lock.sync {
            var results = [MsgStyle]()
            let msgs = allMsgs.prefix(pageSize*currentPage)
            let enuMsgs =  Array(msgs.enumerated())
            enuMsgs.forEach { (i, msg) in
                let style = msgStyleWorker.msgStyle(
                    for: msg,
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
    }
    func didRecieveNoti(_ data: AnyMsgData) async {
        switch data {
        case .newMsg(let msg):
            lock.sync {
                let previous = allMsgs.first
                allMsgs.insert(msg as! Msg, at: 0)
                let newStyle = msgStyleWorker.msgStyle(for: msg as! Msg, at: 0, selectedId: nil, focusedId: nil, msgs: allMsgs)
                if let previous {
                    let previousStyle = msgStyleWorker.msgStyle(for: previous, at: 1, selectedId: nil, focusedId: nil, msgs: allMsgs)
                    self.msgStyles.removeFirst()
                    self.msgStyles.insert((previous, previousStyle), at: 0)
                }
                self.msgStyles.insert((msg as! Msg, newStyle), at: 0)
                self.update()
            }
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
        lock.sync {
            guard currentPage > 1 else { return }
            currentPage = 1
            updateData()
            print("reset")
        }
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
