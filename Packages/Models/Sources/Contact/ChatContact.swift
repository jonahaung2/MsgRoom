//
//  SContact.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 29/6/24.
//

import SwiftData
import Contacts

public struct ChatContact: Conformable {
    
    public let id: String
    public var name: String
    public var mobile: String
    public var photoURL: String
    public var pushToken: String
    public var room: MsgRoom?
    public var persistentId: PersistentIdentifier?
    
    public init(id: String, name: String, mobile: String, photoURL: String, pushToken: String, persistentId: PersistentIdentifier? = nil) {
        self.id = id
        self.name = name
        self.mobile = mobile
        self.photoURL = photoURL
        self.pushToken = pushToken
        self.persistentId = persistentId
    }
    public
    static func fetch(for id: String, context: ModelContext) -> ChatContact? {
        if let conact = PersistedContact.fetch(for: id, context: context) {
            return .init(persisted: conact)
        }
        return nil
    }
}
extension ChatContact: PersistentModelProxy {
    public init?(cnContact: CNContact) {
        let name = cnContact.givenName.isEmpty ? cnContact.middleName + cnContact.familyName : cnContact.givenName
        if name.isEmpty || cnContact.phoneNumbers.isEmpty {
            return nil
        }
        let phone = cnContact.phoneNumbers.first?.value.stringValue ?? ""
        self.init(id: phone, name: name, mobile: phone, photoURL: "", pushToken: "")
    }
}

public extension ChatContact {
    func asPersistentModel(in context: ModelContext) -> PersistedContact {
        if let persistentId, let contact = context.model(for: persistentId) as? Persistent {
            updating(persisted: contact)
            return contact
        }
        let model = Persistent(id: id, name: name, phoneNumber: photoURL, photoUrl: photoURL, pushToken: pushToken)
        context.insert(model)
        return model
    }
    
    init(persisted: PersistedContact) {
        self.init(
            id: persisted.id,
            name: persisted.name,
            mobile: persisted.mobile,
            photoURL: persisted.photoURL,
            pushToken: persisted.pushToken,
            persistentId: persisted.persistentModelID
        )
    }
    
    func updating(persisted: PersistedContact) {
        persisted.name = name
        persisted.mobile = mobile
        persisted.photoURL = photoURL
        persisted.pushToken = pushToken
    }
    typealias Persistent = PersistedContact
}
