//
//  ChatDatasource.swift
//  Msgr
//
//  Created by Aung Ko Min on 27/10/22.
//

import SwiftUI
import XUI
import AsyncQueue
import Models
import Database
import Core

final class RoomDatasource: ObservableObject {
    @Published var updater = 0
    var msgStyles = [MsgDisplayData]()
    private let msgStyleWorker = MsgStyleStylingWorker()
    private var allMsgs = [Msg]()
    private var pageSize = 50
    private var currentPage = 1
    
    var room: Room {
        get { dataProvider.room }
        set { dataProvider.room = newValue }
    }
    
    private var dataProvider: any MsgDatasource
    
    @MainActor init(_ dataProvider: any MsgDatasource) {
        self.dataProvider = dataProvider
        allMsgs = dataProvider.loadMoreMsgsIfNeeded(for: pageSize)
        updateData(nil)
    }
    @MainActor func loadMoreIfNeeded(_ state: RoomStates?) -> Bool {
        currentPage += 1
        allMsgs = dataProvider.loadMoreMsgsIfNeeded(for: currentPage*pageSize)
        updateData(state)
        return true
    }
    
    @MainActor
    func updateData(_ state: RoomStates?) {
        let selectedId = state?.selectedId
        let focusId = state?.focusId
        var results = [MsgDisplayData]()
        allMsgs.enumerated().forEach { (i, msg) in
            let style = msgStyleWorker.msgStyle(
                for: msg,
                at: i,
                selectedId: selectedId,
                focusedId: focusId,
                msgs: allMsgs
            )
            results.append(MsgDisplayData(id: i, msg: msg, style: style))
        }
        self.msgStyles = results
        update()
    }
    func didRecieveNoti(_ data: AnyMsgData) async {
        switch data {
        case .newMsg(let msg):
            await self.dataProvider.didReceiveMsg(msg)
            allMsgs.insert(msg, at: 0)
            await updateData(nil)
        case .updatedMsg(let msg):
            if let i = allMsgs.firstIndex(of: msg) {
                allMsgs.remove(at: i)
                allMsgs.insert(msg, at: i)
                update()
            }
        case .typingStatus(let typingStatus):
            Log(typingStatus)
        }
    }
    func update() {
        updater += 1
    }
    @MainActor func reset() {
        guard currentPage > 1 else { return }
        currentPage = 1
        allMsgs = dataProvider.loadMoreMsgsIfNeeded(for: currentPage*pageSize)
        msgStyleWorker.resetCache()
        updateData(nil)
    }
    
    func updateLastMsg() async {
        @Injected(\.swiftdataRepo) var swiftdataRepo
        if let first = allMsgs.first {
            let sender: Contact? = await first.sender()
            dataProvider.room.lastMsg = .init(msg: first, sender: sender)
            switch await swiftdataRepo.update(room) {
            case .success(let room):
                Log(room)
            case .failure(let error):
                Log(error)
            }
        }
    }
    
    deinit {
        Log("deinit")
    }
}
