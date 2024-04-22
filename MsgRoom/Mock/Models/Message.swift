//
//  Msg.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 1/4/24.
//

import SwiftUI
import XUI
import MsgrCore

@Observable
class Message: MessageRepresentable {
    
    let id: String
    let conId: String
    let date: Date
    var deliveryStatus: MsgDeliveryStatus
    let msgType: MsgType
    let text: String
    var sender: (any ContactRepresentable)
    
    required init(conId: String, date: Date, id: String, deliveryStatus: MsgDeliveryStatus, msgType: MsgType, sender: (any ContactRepresentable), text: String) {
        self.conId = conId
        self.date = date
        self.id = id
        self.deliveryStatus = deliveryStatus
        self.msgType = msgType
        self.sender = sender
        self.text = text
    }
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = Message(conId: conId, date: date, id: id, deliveryStatus: deliveryStatus, msgType: msgType, sender: sender, text: text)
        return copy
    }
}
extension Message {
    static func == (lhs: Message, rhs: Message) -> Bool {
        lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
        id.hash(into: &hasher)
    }
}
