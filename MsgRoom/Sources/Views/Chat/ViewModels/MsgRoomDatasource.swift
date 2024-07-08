//
//  ChatDatasource.swift
//  Msgr
//
//  Created by Aung Ko Min on 27/10/22.
//

import SwiftUI
import XUI

public final class ChatDatasource<Msg: MsgRepresentable, RoomItem: RoomRepresentable, Contact: ContactRepresentable>: ObservableObject {
    
    public typealias MsgStyle = (msg: Msg, style: MsgCellPresenter)
    
    @Published public var updater = 0
    
    private let msgStyleWorker = MsgStyleStylingWorker<Msg, RoomItem, Contact>()
    public var msgStyles = [MsgStyle]()
    
    private let pageSize = 50
    private var currentPage = 1
    public var room: RoomItem { interactor.room as! RoomItem }
    public var selectedId: String?
    private var focusId: String?
    private let lock: os_unfair_lock_t
    private let interactor: any MsgDatasourceProviding
    
    init(_ interactor: any MsgDatasourceProviding) {
        self.interactor = interactor
        self.lock = .allocate(capacity: 1)
        self.lock.initialize(to: os_unfair_lock())
        updateData()
    }
    
    func loadMoreIfNeeded() -> Bool {
        //        guard currentPage*pageSize <= allMsgs.count else {
        //            return false
        //        }
        os_unfair_lock_lock(lock)
        defer { os_unfair_lock_unlock(lock) }
        currentPage += 1
        updateData()
        return true
    }
    
    func updateData() {
        let msgs: [Msg] = interactor.loadMoreMsgsIfNeeded(for: currentPage * pageSize)
        var results = [MsgStyle]()
        msgs.enumerated().forEach { (i, msg) in
            let style = msgStyleWorker.msgStyle(
                for: msg,
                at: i,
                selectedId: selectedId,
                focusedId: focusId,
                msgs: msgs
            )
            let msgStyle = MsgStyle(msg, style)
            results.append(msgStyle)
        }
        self.msgStyles = results
        update()
    }
    func didRecieveNoti(_ data: AnyMsgData) {
        switch data {
        case .newMsg(let msg):
            interactor.didReceiveMsg(msg)
            updateData()
        case .updatedMsg(let msg):
            break
            //            if let thisMsg = msg as? Msg, let i = allMsgs.firstIndex(of: thisMsg) {
            //                allMsgs.remove(at: i)
            //                allMsgs.insert(thisMsg, at: i)
            //                update()
            //            }
        case .typingStatus(let typingStatus):
            Log(typingStatus)
        }
    }
    func update() {
        updater += 1
    }
    func reset() {
        guard currentPage > 1 else { return }
        os_unfair_lock_lock(lock)
        defer { os_unfair_lock_unlock(lock) }
        currentPage = 1
        updateData()
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
    
    @MainActor
    func updateLastMsg() {
        if let msg: Msg = interactor.getFirstMsg() {
            let sender: Contact? = msg.sender()
            room.lastMsg = .init(msg: msg, sender: sender)
        }
    }
    
    deinit {
        Log("deinit")
    }
}
