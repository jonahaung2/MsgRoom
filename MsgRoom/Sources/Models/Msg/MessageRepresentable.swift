//
//  MsgRepresentable.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 12/3/24.
//

import SwiftUI

public protocol MessageRepresentable: AnyObject, Observable, Hashable, Identifiable, NSCopying {
    typealias ContactItem = any ContactRepresentable
    var id: String { get }
    var conId: String { get }
    var msgType: MessageType { get }
    var sender: ContactItem? { get }
    var date: Date { get }
    var deliveryStatus: MessageDeliveryStatus { get set }
    var text: String { get }
    
    init(
        conId: String,
        date: Date,
        id: String,
        deliveryStatus: MessageDeliveryStatus,
        msgType: MessageType,
        sender: (any ContactRepresentable)?,
        text: String
    )
}
extension MessageRepresentable {
    var recieptType: MessageRecipientType {
        sender == nil ? .Send : .Receive
    }
}
