//
//  MsgRepresentable.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 12/3/24.
//

import SwiftUI
import XUI
import SwiftData

public protocol MsgRepresentable: Conformable, AnyObject {
    
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
    ) async throws -> (any MsgRepresentable)?
    
    func sender<T>() -> T? where T: ContactRepresentable
}

public extension MsgRepresentable {
    var recieptType: MsgRecipient {
        senderID == CurrentUser.current.id ? .Send : .Receive
    }
}
