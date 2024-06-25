//
//  Contact.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 1/4/24.
//

import Foundation
import XUI


public final class Contact: ContactRepresentable {
    public let name: String
    public let id: String
    public let phoneNumber: String
    public let photoUrl: String
    public let pushToken: String
    
    required public init(id: String, name: String, phoneNumber: String, photoUrl: String, pushToken: String) {
        self.id = id
        self.name = name
        self.phoneNumber = phoneNumber
        self.photoUrl = photoUrl
        self.pushToken = "a930f7b76b2c4b9122875556bc36fa5873bebe3237278244e2339a991288a5ec"
    }
    static public var currentUser: any ContactRepresentable = Contact(id: "2", name: "Jonah Aung", phoneNumber: "88585229", photoUrl: "https://avatars.githubusercontent.com/u/108913030?v=4", pushToken: "a930f7b76b2c4b9122875556bc36fa5873bebe3237278244e2339a991288a5ec")
    
    public var isCurrentUser: Bool { id == Self.currentUser.id }
}

extension Contact {
    
    public func hash(into hasher: inout Hasher) {
        id.hash(into: &hasher)
    }
    public static func == (lhs: Contact, rhs: Contact) -> Bool {
        lhs.id == rhs.id
    }
}
