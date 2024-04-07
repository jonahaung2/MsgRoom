//
//  MsgRepresentable.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 12/3/24.
//

import SwiftUI

protocol MessageRepresentable: AnyObject, Hashable, Observable {

    associatedtype MsgItem = MessageRepresentable
    associatedtype ConItem = ConversationRepresentable
    associatedtype ContactItem = Contactable
    
    var id: String { get }
    var conId: String { get }
    var msgType: MessageType { get }
    var sender: any Contactable { get }
    var date: Date { get }
    var deliveryStatus: MessageDeliveryStatus { get set }
    var text: String { get }
    
    init(
        conId: String,
        date: Date,
        id: String,
        deliveryStatus: MessageDeliveryStatus,
        msgType: MessageType,
        sender: any Contactable,
        text: String
    )
    
}
extension MessageRepresentable {
    var recieptType: MessageRecipientType {
        sender.id == Contact.currentUser.id ? .Send : .Receive
    }
}
