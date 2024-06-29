//
//  Msg+CoreDataProperties.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 27/6/24.
//
//

import Foundation
import CoreData
import XUI

extension Msg: MsgRepresentable, @unchecked Sendable {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Msg> {
        return NSFetchRequest<Msg>(entityName: "Msg")
    }
    @NSManaged public var conID: String
    @NSManaged public var date: Date
    @NSManaged public var deliveryStatus_: Int16
    @NSManaged public var id: String
    @NSManaged public var msgKind_: Int16
    @NSManaged public var senderID: String
    @NSManaged public var text: String
}

extension Msg {
    @MainActor
    public func sender<T>() -> T? where T : ContactRepresentable {
        Contact.fetch(for: senderID)
    }
    public static func create(conId: String, date: Date, id: String, deliveryStatus: MsgDelivery, msgType: MsgKind, senderId: String, text: String) async throws -> (any MsgRepresentable)? {
        @Injected(\.coreDataStore) var store
        let msg = Msg(context: store.backgroundContext)
        msg.conID = conId
        msg.date = date
        msg.id = id
        msg.deliveryStatus_ = Int16(deliveryStatus.rawValue)
        msg.msgKind_ = Int16(msgType.rawValue)
        msg.senderID = senderId
        msg.text = text
        try await store.insert(model: msg, informSavedNotification: true)
        return msg
    }
    public var msgKind: MsgKind {
        .init(rawValue: Int(msgKind_)) ?? .Text
    }
    public var deliveryStatus: MsgDelivery {
        get { .init(rawValue: Int(deliveryStatus_)) ?? .Sending }
        set { deliveryStatus_ = Int16(newValue.rawValue) }
    }
}
