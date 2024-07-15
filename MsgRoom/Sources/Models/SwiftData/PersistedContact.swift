//
//  ContactData.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 14/7/24.
//

import Foundation
import SwiftData
import XUI

@Model
final class PersistedContact: IdentifiableByProxy {
    @Attribute(.unique) let id: String
    var name: String
    var mobile: String
    var photoURL: String
    var pushToken: String
    
    init(id: String, name: String, phoneNumber mobile: String, photoUrl photoURL: String, pushToken: String) {
        self.id = id
        self.name = name
        self.mobile = mobile
        self.photoURL = photoURL
        self.pushToken = pushToken
    }
    static var cachee = [String: Contact]()
}

extension PersistedContact {
    @MainActor
    public static func fetch(for id: String) -> Contact? {
        if let cached = PersistedContact.cachee[id] {
            return cached
        }
        @Injected(\.swiftDatabase) var database
        do {
            let existings = try database.container.mainContext.fetch(.init(predicate: #Predicate<PersistedContact>{ model in
                model.id == id
            }))
            if let first = existings.first {
                return .init(persisted: first)
            }
            return nil
        } catch {
            Log(error)
            return nil
        }
    }
}
