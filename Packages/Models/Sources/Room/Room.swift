//
//  Room.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 29/6/24.
//

import Foundation
import SwiftData

public struct Room: Conformable {
    public let id: String
    public var name: String
    public var type: RoomType
    public var createdDate: Date
    public var photoURL: String?
    public var contacts: [Contact] = []
    public var lastMsg: LastMsg?
    public var persistentId: PersistentIdentifier?
    
    public init(id: String, name: String, type: RoomType, createdDate: Date, photoURL: String?, contactspersistentIds: [PersistentIdentifier]) {
        self.id = id
        self.name = name
        self.type = type
        self.createdDate = createdDate
        self.photoURL = photoURL
        self.contacts = []
    }
    public init(id: String, name: String, type: RoomType, createdDate: Date, photoURL: String?, persistentId: PersistentIdentifier? = nil, contacts: [Contact], lastMsg: LastMsg? = nil) {
        self.init(id: id, name: name, type: type, createdDate: createdDate, photoURL: photoURL, contactspersistentIds: contacts.compactMap{ $0.persistentId })
        self.persistentId = persistentId
        self.contacts = contacts
        self.lastMsg = lastMsg
    }
    @MainActor public  static func fetch(for id: String, context: ModelContext) -> Room? {
        if let repo = PersistedRoom.fetch(for: id, context: context) {
            return .init(persisted: repo)
        }
        return nil
    }
}

extension Room: PersistentModelProxy {
    public typealias Persistent = PersistedRoom
    
    public func asPersistentModel(in context: ModelContext) -> Persistent {
        if let persistentId, let room = context.model(for: persistentId) as? Persistent {
            updating(persisted: room)
            return room
        }
        let model = Persistent(id: id, name: name, type: type, createdDate: createdDate, photoURL: photoURL)
        context.insert(model)
        
        return model
    }
    
    public init(persisted: Persistent) {
        self.init(
            id: persisted.id,
            name: persisted.name,
            type: persisted.type,
            createdDate: persisted.createdDate,
            photoURL: persisted.photoURL,
            persistentId: persisted.persistentModelID, 
            contacts: persisted.contacts?.compactMap{ Contact(persisted: $0)} ?? [],
            lastMsg: persisted.lastMsg)
    }
    
    public func updating(persisted: Persistent) {
        persisted.id = id
        persisted.name = name
        persisted.lastMsg = lastMsg
        persisted.photoURL = photoURL
        persisted.lastMsg = lastMsg
        persisted.contacts = contacts.map{ $0.asPersistentModel(in: persisted.modelContext!) }
    }
}
