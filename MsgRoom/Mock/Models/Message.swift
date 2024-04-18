//
//  Msg.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 1/4/24.
//

import SwiftUI
import XUI

@Observable
class Message: MsgKind {
    
    let id: String
    let conId: String
    let date: Date
    var deliveryStatus: MessageDeliveryStatus
    let msgType: MessageType
    let text: String
    var sender: Contact?
    
    required init(conId: String, date: Date, id: String, deliveryStatus: MessageDeliveryStatus, msgType: MessageType, sender: Contact?, text: String) {
        self.conId = conId
        self.date = date
        self.id = id
        self.deliveryStatus = deliveryStatus
        self.msgType = msgType
        self.sender = sender
        self.text = text
    }
}

extension Message {
    static func == (lhs: Message, rhs: Message) -> Bool {
        lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
        id.hash(into: &hasher)
        conId.hash(into: &hasher)
        date.hash(into: &hasher)
        deliveryStatus.hash(into: &hasher)
        sender?.hash(into: &hasher)
        text.hash(into: &hasher)
    }
}
