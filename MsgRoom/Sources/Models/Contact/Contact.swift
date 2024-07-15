//
//  SContact.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 29/6/24.
//

import Foundation
import SwiftData
import XUI
import Contacts

struct Contact: Conformable {
    let id: String
    var name: String
    var mobile: String
    var photoURL: String
    var pushToken: String
    var room: Room?
    var persistentId: PersistentIdentifier?
    
    init(id: String, name: String, mobile: String, photoURL: String, pushToken: String, persistentId: PersistentIdentifier? = nil) {
        self.id = id
        self.name = name
        self.mobile = mobile
        self.photoURL = photoURL
        self.pushToken = pushToken
        self.persistentId = persistentId
    }
    @MainActor
    static func fetch(for id: String) -> Self? {
        PersistedContact.fetch(for: id)
    }
    
}
extension Contact {
    init?(cnContact: CNContact) {
        let name = cnContact.givenName.isEmpty ? cnContact.middleName + cnContact.familyName : cnContact.givenName
        if name.isWhitespace || cnContact.phoneNumbers.isEmpty {
            return nil
        }
        let phone = cnContact.phoneNumbers.first?.value.stringValue ?? ""
        self.init(id: phone, name: name, mobile: phone, photoURL: DemoImages.demoPhotosURLs.random()!.absoluteString, pushToken: "")
    }
}

extension Contact: PersistentModelProxy {
    
    func asPersistentModel(in context: ModelContext) -> PersistedContact {
        if let persistentId, let contact = context.model(for: persistentId) as? Persistent {
            return contact
        }
        let model = Persistent(id: id, name: name, phoneNumber: photoURL, photoUrl: photoURL, pushToken: pushToken)
        context.insert(model)
        updating(persisted: model)
        return model
    }
    
    public init(persisted: PersistedContact) {
        self.init(
            id: persisted.id,
            name: persisted.name,
            mobile: persisted.mobile,
            photoURL: persisted.photoURL,
            pushToken: persisted.pushToken,
            persistentId: persisted.persistentModelID
        )
    }
    
    public func updating(persisted: PersistedContact) {
        persisted.name = name
        persisted.mobile = mobile
        persisted.photoURL = photoURL
        persisted.pushToken = pushToken
    }
    public typealias Persistent = PersistedContact
    
}
