//
//  SContact.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 29/6/24.
//

import Foundation
import SwiftData
import XUI
import MsgRoomCore
@Model
final class Contact: ContactRepresentable {
    @Attribute(.unique)
    let id: String
    var name: String
    var mobile: String
    var photoURL: String
    var pushToken: String
    var room: Room?
    init(id: String, name: String, phoneNumber mobile: String, photoUrl photoURL: String, pushToken: String) {
        self.id = id
        self.name = name
        self.mobile = mobile
        self.photoURL = photoURL
        self.pushToken = pushToken
    }
    
    static var cachee = [String: Contact]()
    
}

extension Contact {
    @MainActor
    public static func fetch<T>(for id: String) -> T? where T : ContactRepresentable {
        if let cached = Contact.cachee[id] {
            return cached as? T
        }
        @Injected(\.swiftDatabase) var database
        do {
            let existings = try database.container.mainContext.fetch(.init(predicate: #Predicate<Contact>{ model in
                model.id == id
            }))
            return existings.first as? T
        } catch {
            Log(error)
            return nil
        }
    }
}
