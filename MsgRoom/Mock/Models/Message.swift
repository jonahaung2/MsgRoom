//
//  Msg.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 1/4/24.
//

import SwiftUI
import XUI
import SwiftData

@Model
final class Message: MessageRepresentable {
    
    @Attribute(.unique) var id: String
    var senderId: String
    var conId: String
    var date: Date
    var deliveryStatus: MessageDeliveryStatus
    var msgType: MsgKind
    var text: String
    
    required init(conId: String, date: Date, id: String, deliveryStatus: MessageDeliveryStatus, msgType: MsgKind, senderId: String, text: String) {
        self.conId = conId
        self.date = date
        self.id = id
        self.deliveryStatus = deliveryStatus
        self.msgType = msgType
        self.senderId = senderId
        self.text = text
    }
}
