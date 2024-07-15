//
//  Msg.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 8/7/24.
//

import Foundation
import CoreData
import XUI

//public struct Msg: MsgRepresentable {
//    public var id: String
//    public var conID: String
//    public var msgKind: MsgKind
//    public var senderID: String
//    public var date: Date
//    public var deliveryStatus: MsgDelivery
//    public var text: String
//    public var managedIdUrl: URL?
//}
//public extension Msg {
//    init(
//        roomID: String,
//        senderID: String,
//        msgKind: MsgKind,
//        text: String) {
//            self.init(
//                id: UUID().uuidString,
//                conID: roomID,
//                msgKind: msgKind,
//                senderID: senderID,
//                date: .now,
//                deliveryStatus: .Sending,
//                text: text, managedIdUrl: nil
//            )
//        }
//}
//public extension Msg {
//    @MainActor func sender<T>() -> T? where T : ContactRepresentable {
//        T.fetch(for: senderID)
//    }
//}
//extension Msg: UnmanagedModel {
//    
//    public typealias ManagedModel = RepoMsg
//    
//    public func asManagedModel(in context: NSManagedObjectContext) throws -> RepoMsg {
//        let managed = RepoMsg(context: context)
//        try updating(managed: managed)
//        return managed
//    }
//    
//    public func updating(managed: RepoMsg) throws {
//        managed.id = id
//        managed.conID = conID
//        managed.senderID = senderID
//        managed.msgKind_ = msgKind.rawValue
//        managed.date = date
//        managed.deliveryStatus_ = deliveryStatus.rawValue
//        managed.text = text
//    }
//    
//    public init(managed: RepoMsg) throws {
//        self.init(
//            id: managed.id,
//            conID: managed.conID,
//            msgKind: managed.msgKind,
//            senderID: managed.senderID,
//            date: managed.date,
//            deliveryStatus: managed.deliveryStatus,
//            text: managed.text,
//            managedIdUrl: managed.objectID.uriRepresentation()
//        )
//    }
//}
