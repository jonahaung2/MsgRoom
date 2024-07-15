//
//  Message.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 11/7/24.
//

import Foundation
import SwiftData

struct Msg: Conformable {
    let id: String
    let conID: String
    let msgKind: MsgKind
    let senderID: String
    let date: Date
    var deliveryStatus: MsgDeliveryStatus
    var text: String
    var persistentId: PersistentIdentifier?
    
}
extension Msg {
    init(
        roomID: String,
        senderID: String,
        msgKind: MsgKind,
        text: String) {
            self.init(
                id: UUID().uuidString,
                conID: roomID,
                msgKind: msgKind,
                senderID: senderID,
                date: .now,
                deliveryStatus: .Sending,
                text: text, persistentId: nil
            )
        }
}
extension Msg {
    var recieptType: MsgRecipient {
        senderID == CurrentUser.current.id ? .Send : .Receive
    }
    @MainActor func sender() -> Contact? {
        Contact.fetch(for: senderID)
    }
}

extension Msg: PersistentModelProxy {
    public func asPersistentModel(in context: ModelContext) -> MsgData {
        if let persistentId, let room = context.model(for: persistentId) as? Persistent {
            return room
        }
        let model = Persistent(senderID: senderID, conID: conID, msgKind: msgKind, text: text, deliveryStatus: deliveryStatus)
        context.insert(model)
        updating(persisted: model)
        return model
    }
    
    public init(persisted: MsgData) {
        self.init(id: persisted.id, conID: persisted.conID, msgKind: persisted.msgKind, senderID: persisted.senderID, date: persisted.date, deliveryStatus: persisted.deliveryStatus, text: persisted.text, persistentId: persisted.persistentModelID)
    }
    
    public func updating(persisted: MsgData) {
        persisted.deliveryStatus = deliveryStatus
    }
    
    public typealias Persistent = MsgData
}
