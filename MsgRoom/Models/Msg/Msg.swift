//
//  Msg.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 1/4/24.
//

import SwiftUI
import XUI

class Msg: Msgable {
    let id: String
    let conId: String
    let date: Date
    var deliveryStatus_: Int16
    let msgType_: Int16
    var progress: Int16
    let senderId: String
    let text: String
    
    required init(conId: String, date: Date, id: String, deliveryStatus_: Int16, msgType_: Int16, progress: Int16, senderId: String, text: String) {
        self.conId = conId
        self.date = date
        self.id = id
        self.deliveryStatus_ = deliveryStatus_
        self.msgType_ = msgType_
        self.progress = progress
        self.senderId = senderId
        self.text = text
    }
}
extension Msg {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    static func == (lhs: Msg, rhs: Msg) -> Bool {
        lhs.id == rhs.id
    }
}
extension Msg {
    static var msgs: [any Msgable] {
        var msgs = [Msg]()
        [0...60].forEach{ _ in
                let msg = Msg(conId: "1", date: .now, id: UUID().uuidString, deliveryStatus_: 0, msgType_: MsgType.Text.rawValue, progress: 0, senderId: CurrentUser.id, text: Lorem.random)
            msgs.append(msg)
        }
        return msgs
    }
}
