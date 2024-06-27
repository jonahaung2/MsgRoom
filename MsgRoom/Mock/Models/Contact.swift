//
//  Contact.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 1/4/24.
//

import Foundation
import XUI
import SwiftData

@Model
final class Contact: ContactRepresentable {
    @Attribute(.unique) var id: String
    var name: String
    @Attribute(.unique) var phoneNumber: String
    var photoUrl: String
    var pushToken: String
    
    required init(id: String, name: String, phoneNumber: String, photoUrl: String, pushToken: String) {
        self.id = id
        self.name = name
        self.phoneNumber = phoneNumber
        self.photoUrl = photoUrl
        self.pushToken = "a930f7b76b2c4b9122875556bc36fa5873bebe3237278244e2339a991288a5ec"
    }
    static var currentUser: any ContactRepresentable = Contact(id: UUID().uuidString, name: "Jonah Aung", phoneNumber: "88585229", photoUrl: "https://avatars.githubusercontent.com/u/108913030?v=4", pushToken: "a930f7b76b2c4b9122875556bc36fa5873bebe3237278244e2339a991288a5ec")
    
    var isCurrentUser: Bool { id == Self.currentUser.id }
}
