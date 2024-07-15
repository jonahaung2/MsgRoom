//
//  Room.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 29/6/24.
//

import Foundation
import SwiftData
import XUI

struct Room: Conformable {
    let id: String
    var name: String
    var type: RoomType
    var createdDate: Date
    var photoURL: String?
    var contacts: [Contact] = []
    var lastMsg: LastMsg?
    var persistentId: PersistentIdentifier?
    
    init(id: String, name: String, type: RoomType, createdDate: Date, photoURL: String?, contactspersistentIds: [PersistentIdentifier]) {
        self.id = id
        self.name = name
        self.type = type
        self.createdDate = createdDate
        self.photoURL = photoURL
        self.contacts = []
    }
    init(id: String, name: String, type: RoomType, createdDate: Date, photoURL: String?, persistentId: PersistentIdentifier? = nil, contacts: [Contact], lastMsg: LastMsg? = nil) {
        self.init(id: id, name: name, type: type, createdDate: createdDate, photoURL: photoURL, contactspersistentIds: contacts.compactMap{ $0.persistentId })
        self.persistentId = persistentId
        self.contacts = contacts
        self.lastMsg = lastMsg
    }
    @MainActor static func fetch(for id: String, context: ModelContext) -> Room? {
        if let repo = PersistedRoom.fetch(for: id, context: context) {
            return .init(persisted: repo)
        }
        return nil
    }
}

extension Room: PersistentModelProxy {
    typealias Persistent = PersistedRoom
    
    func asPersistentModel(in context: ModelContext) -> Persistent {
        if let persistentId, let room = context.model(for: persistentId) as? Persistent {
            return room
        }
        let model = Persistent(id: id, name: name, type: type, createdDate: createdDate, photoURL: photoURL)
        context.insert(model)
        updating(persisted: model)
        return model
    }
    
    init(persisted: Persistent) {
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
    
    func updating(persisted: Persistent) {
        persisted.id = id
        persisted.name = name
        persisted.lastMsg = lastMsg
        persisted.photoURL = photoURL
        persisted.lastMsg = lastMsg
        persisted.contacts = contacts.map{ $0.asPersistentModel(in: persisted.modelContext!) }
    }
}
