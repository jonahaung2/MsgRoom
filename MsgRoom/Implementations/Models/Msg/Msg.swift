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
    let text: String
    
    weak var sender: Sender?
    
    init(conId: String, date: Date, id: String, deliveryStatus: MsgDeliveryStatus, msgType: MsgType, progress: Int16, sender: Sender, text: String) {
        self.conId = conId
        self.date = date
        self.id = id
        self.deliveryStatus = deliveryStatus
        self.msgType = msgType
        self.progress = progress
        self.sender = sender
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
    static var msgs: [Msg] {
        var msgs = [Msg]()
        (0...60).forEach{ _ in
            let msg = Msg(conId: "1", date: .now, id: UUID().uuidString, deliveryStatus: .Sending, msgType: MsgType.Text, progress: 0, sender: CurrentUser.contact, text: Lorem.random)
            msgs.append(msg)
        }
        return msgs
    }
}
