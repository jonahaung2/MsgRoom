//
//  Msg.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 1/4/24.
//

import SwiftUI
import XUI

struct Message: MessageRepresentable {
    
    var senderId: String
    let id: String
    let conId: String
    let date: Date
    var deliveryStatus: MessageDeliveryStatus
    let msgType: MsgKind
    let text: String
    
    init(conId: String, date: Date, id: String, deliveryStatus: MessageDeliveryStatus, msgType: MsgKind, senderId: String, text: String) {
        self.conId = conId
        self.date = date
        self.id = id
        self.deliveryStatus = deliveryStatus
        self.msgType = msgType
        self.senderId = senderId
        self.text = text
    }
}
