//
//  MsgRepresentable.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 12/3/24.
//

import SwiftUI
import XUI
import SwiftData

public protocol Msg_: Conformable, AnyObject {
    var id: String { get }
    var conID: String { get }
    var msgKind: MsgKind { get }
    var senderID: String { get }
    var date: Date { get }
    var deliveryStatus: MsgDelivery { get set }
    var text: String { get set }
    
    static func create(
        conId: String,
        date: Date,
        id: String,
        deliveryStatus: MsgDelivery,
        msgType: MsgKind,
        senderId: String,
        text: String
    ) async throws -> (any Msg_)?
}

extension Msg_ {
    var recieptType: MsgRecipient {
        senderID == currentUserId ? .Send : .Receive
    }
}
