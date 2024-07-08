//
//  ChatInteractor.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 8/7/24.
//

import Foundation

final class MsgDatasourceProvider<MsgItem: MsgRepresentable>: MsgDatasourceProviding {
    
    var room: any RoomRepresentable
    var pageSize: Int = 30
    var allMsgs = [MsgItem]()
    
    init(_ room: any RoomRepresentable) {
        self.room = room
        self.allMsgs = room.msgs()
    }
    func didReceiveMsg<T>(_ msg: T) {
        allMsgs.insert(msg as! MsgItem, at: 0)
    }
    func fetchInitialMsgs<T>(for i: Int) -> [T] where T : MsgRepresentable {
        Array(allMsgs.prefix(upTo: i)) as! [T]
    }
    
    func loadMoreMsgsIfNeeded<T>(for i: Int) -> [T] where T : MsgRepresentable {
        Array(room.msgs().prefix(i))
    }
    func getFirstMsg<Msg>() -> Msg? {
        allMsgs.first as? Msg
    }
}
