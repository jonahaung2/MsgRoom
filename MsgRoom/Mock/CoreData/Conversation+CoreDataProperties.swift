//
//  Conversation+CoreDataProperties.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 27/6/24.
//
//

import Foundation
import CoreData
import XUI

extension Conversation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Conversation> {
        return NSFetchRequest<Conversation>(entityName: "Conversation")
    }

    @NSManaged public var createdDate: Date
    @NSManaged public var id: String
    @NSManaged public var name: String
    @NSManaged public var photoURL: String?
    @NSManaged public var type_: Int16
    @NSManaged public var contacts: NSOrderedSet?
    @NSManaged public var msgs: NSOrderedSet?

}

extension Conversation: Conversation_, @unchecked Sendable {
    var type: ConversationType {
        .init(rawValue: Int(self.type_)) ?? .single
    }
    
    static func create(id: String, date: Date, name: String, photoUrl: String, type: ConversationType) async throws -> (any Conversation_)? {
        @Injected(\.coreDataStore) var store
        let x = Conversation(context: store.backgroundContext)
        x.createdDate = date
        x.id = id
        x.name = name
        x.photoURL = photoUrl
        x.type_ = Int16(type.rawValue)
        try await store.insert(model: x, informSavedNotification: true)
        return await store.mainObject(with: x.objectID) as? Conversation
    }
}
