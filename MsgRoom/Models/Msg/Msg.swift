//
//  Msg.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 1/4/24.
//

import SwiftUI
import XUI

final class Msg: Msgable {
    let id: String
    let conId: String
    let date: Date
    var deliveryStatus: MsgDeliveryStatus
    let msgType: MsgType
    var progress: Int16
    let senderId: String
    let text: String
    
    required init(conId: String, date: Date, id: String, deliveryStatus: MsgDeliveryStatus, msgType: MsgType, progress: Int16, senderId: String, text: String) {
        self.conId = conId
        self.date = date
        self.id = id
        self.deliveryStatus = deliveryStatus
        self.msgType = msgType
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
            let msg = Msg(conId: "1", date: .now, id: UUID().uuidString, deliveryStatus: .Sending, msgType: MsgType.Text, progress: 0, senderId: CurrentUser.id, text: Lorem.random)
            msgs.append(msg)
        }
        return msgs
    }
}
