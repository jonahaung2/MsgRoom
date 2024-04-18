//
//  MsgRepresentable.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 12/3/24.
//

import SwiftUI

protocol MsgKind: AnyObject, Observable, Hashable, Identifiable {
    var id: String { get }
    var conId: String { get }
    var msgType: MessageType { get }
    var sender: Contact? { get }
    var date: Date { get }
    var deliveryStatus: MessageDeliveryStatus { get set }
    var text: String { get }
    
    init(
        conId: String,
        date: Date,
        id: String,
        deliveryStatus: MessageDeliveryStatus,
        msgType: MessageType,
        sender: Contact?,
        text: String
    )
}
extension MsgKind {
    var recieptType: MessageRecipientType {
        sender?.id == Contact.currentUser.id ? .Send : .Receive
    }
}
