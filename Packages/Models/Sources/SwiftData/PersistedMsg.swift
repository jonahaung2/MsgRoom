//
//  MsgData.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 11/7/24.
//

import Foundation
import SwiftData

@Model
public final class PersistedMsg: IdentifiableByProxy {
    @Attribute(.unique) public var id: String
    public var senderID: String
    public var conID: String
    public var msgKind: MsgKind
    public var text: String
    public var date: Date
    public var deliveryStatus: MsgDeliveryStatus
    
    public init(
        id: String = UUID().uuidString,
        senderID: String,
        conID: String,
        msgKind: MsgKind,
        text: String,
        date: Date = .now,
        deliveryStatus: MsgDeliveryStatus
    ) {
        self.id = id
        self.senderID = senderID
        self.conID = conID
        self.msgKind = msgKind
        self.text = text
        self.date = date
        self.deliveryStatus = deliveryStatus
    }
}
