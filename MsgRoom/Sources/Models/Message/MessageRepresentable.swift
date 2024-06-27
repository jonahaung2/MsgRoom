//
//  MsgRepresentable.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 12/3/24.
//

import SwiftUI
import XUI

public protocol MessageRepresentable: Conformable {
    
    var id: String { get set }
    var conId: String { get set }
    var msgType: MsgKind { get set }
    var senderId: String { get set }
    var date: Date { get set }
    var deliveryStatus: MessageDeliveryStatus { get set }
    var text: String { get set }
    
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
