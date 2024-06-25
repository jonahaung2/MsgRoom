//
//  MsgRepresentable.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 12/3/24.
//

import SwiftUI

public protocol MessageRepresentable: Comformable {
    
    var id: String { get }
    var conId: String { get }
    var msgType: MsgKind { get }
    var senderId: String { get }
    var date: Date { get }
    var deliveryStatus: MessageDeliveryStatus { get set }
    var text: String { get }
    
    init(
        conId: String,
        date: Date,
        id: String,
        deliveryStatus: MessageDeliveryStatus,
        msgType: MsgKind,
        senderId: String,
        text: String
    )
}
extension MessageRepresentable {
    var recieptType: MessageRecipientType {
        senderId == Contact.currentUser.id ? .Send : .Receive
    }
}
