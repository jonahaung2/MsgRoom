//
//  Room.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 29/6/24.
//

import Foundation
import SwiftData

public struct Conversation: Conformable {
    
    public let id: String
    public var name: String
    public var type: MsgRoomType
    public var createdDate: Date
    public var photoURL: String?
    public var contact: Contact?
    public var members: [Contact]?
    public var lastMsg: LastMsg?
    public var persistentId: PersistentIdentifier?
    
    public init(
        id: String,
        name: String,
        type: MsgRoomType,
        createdDate: Date,
        photoURL: String?,
        contact: Contact?,
        members: [Contact]?,
        lastMsg:
        LastMsg? = nil, persistentId:
        PersistentIdentifier? = nil
    ) {
        self.id = id
        self.name = name
        self.type = type
        self.createdDate = createdDate
        self.photoURL = photoURL
        self.contact = contact
        self.members = members
        self.lastMsg = lastMsg
        self.persistentId = persistentId
    }
}

extension Conversation: PersistentModelProxy {
    public typealias Persistent = PersistedRoom
    
    public mutating func asPersistentModel(in context: ModelContext) -> Persistent {
        if let persistentId, let room = context.model(for: persistentId) as? Persistent {
            updating(persisted: room)
            return room
        }
        let model: PersistedRoom
        switch type {
        case .single:
            let pContact = contact?.asPersistentModel(in: context) ?? .init(id: id, name: name, phoneNumber: "", photoUrl: photoURL ?? "", pushToken: "")
            model = .init(id: id, createdDate: createdDate, contact: pContact)
        case .group:
            var pContacts = [PContact]()
            members?.forEach { each in
                let pContact = each.asPersistentModel(in: context)
                pContacts.append(pContact)
            }
            model = PersistedRoom(id: id, name: name, createdDate: createdDate, photoURL: photoURL, members: pContacts)
        }
        context.insert(model)
        persistentId = model.persistentModelID
        return model
    }
    
    public init(persisted: Persistent) {
        let contact: Contact? = {
            if let persistedContact = persisted.contact {
                return .init(persisted: persistedContact)
            }
            return nil
        }()
        let members: [Contact]? = {
            if let persistedMembers = persisted.members {
                return persistedMembers.compactMap{ .init(persisted: $0) }
            }
            return nil
        }()
        self.init(
            id: persisted.id,
            name: persisted.name,
            type: persisted.type,
            createdDate: persisted.createdDate,
            photoURL: persisted.photoURL,
            contact: contact,
            members: members,
            lastMsg: persisted.lastMsg,
            persistentId: persisted.persistentModelID
        )
    }
    public func updating(persisted: Persistent) {
        persisted.name = name
        persisted.photoURL = photoURL
        persisted.lastMsg = lastMsg
        if let context = persisted.modelContext {
            persisted.contact = contact?.asPersistentModel(in: context)
            persisted.members = members?.map{ $0.asPersistentModel(in: context) }
        }
    }
}
