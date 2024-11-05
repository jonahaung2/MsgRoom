//
//  Message.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 11/7/24.
//

import Foundation
import SwiftData

public struct Msg: Conformable {
    public let id: String
    public let conID: String
    public let msgKind: MsgKind
    public let senderID: String
    public let date: Date
    public var deliveryStatus: MsgDeliveryStatus
    public var text: String
    public var persistentId: PersistentIdentifier?
}
extension Msg: Codable {}

public extension Msg {
    
    init(
        conID: String,
        senderID: String,
        msgKind: MsgKind,
        text: String) {
            self.init(
                id: UUID().uuidString,
                conID: conID,
                msgKind: msgKind,
                senderID: senderID,
                date: .now,
                deliveryStatus: .Sending,
                text: text,
                persistentId: nil
            )
        }
}
public extension Msg {
    var recieptType: MsgRecipient {
        senderID == CurrentUser.current.id ? .Send : .Receive
    }
}

extension Msg: PersistentModelProxy {
    public func asPersistentModel(in context: ModelContext) -> PMsg {
        if let persistentId, let existingObject = context.model(for: persistentId) as? Persistent {
            updating(persisted: existingObject)
            return existingObject
        }
        let model = Persistent(
            id: id,
            senderID: senderID,
            conID: conID,
            msgKind: msgKind,
            text: text,
            deliveryStatus: deliveryStatus
        )
        context.insert(model)
        return model
    }
    
    public init(persisted: PMsg) {
        self.init(
            id: persisted.id,
            conID: persisted.conID,
            msgKind: persisted.msgKind,
            senderID: persisted.senderID,
            date: persisted.date,
            deliveryStatus: persisted.deliveryStatus,
            text: persisted.text,
            persistentId: persisted.persistentModelID
        )
    }
    
    public func updating(persisted: PMsg) {
        persisted.id = id
        persisted.deliveryStatus = deliveryStatus
    }
    
    public typealias Persistent = PMsg
}
