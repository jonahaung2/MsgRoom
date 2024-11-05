//
//  RoomData.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 14/7/24.
//
import Foundation
import SwiftData

@Model
public final class PConversation: IdentifiableByProxy {
    @Attribute(.unique) public var id: String
    public var name: String
    public var type: MsgRoomType
    public var createdDate: Date
    public var photoURL: String?
    public var lastMsg: LastMsg?
    
    @Relationship(inverse: \PContact.room) var contact: PContact?
    @Relationship(inverse: \PContact.groups) var members: [PContact]?
    
    public init(id: String, createdDate: Date, contact: PContact) {
        self.id = id
        self.name = contact.name
        self.type = .single
        self.createdDate = createdDate
        self.photoURL = contact.photoURL
        self.contact = contact
    }
    public init(id: String, name: String, createdDate: Date, photoURL: String?, members: [PContact]) {
        self.id = id
        self.name = name
        self.type = .group
        self.createdDate = createdDate
        self.photoURL = photoURL
        self.members = members
    }
}

//public extension PersistedRoom {
//    @MainActor
//    static func fetch(for id: String, context: ModelContext) -> PersistedRoom? {
//        var descriptor = FetchDescriptor<PersistedRoom>(
//            predicate: #Predicate { $0.id == id },
//            sortBy: [
//                .init(\.createdDate)
//            ]
//        )
//        descriptor.fetchLimit = 1
//        descriptor.includePendingChanges = true
//        do {
//            let existings = try context.fetch(descriptor)
//            return existings.first
//        } catch {
//            return nil
//        }
//    }
//}
