//
//  Contact.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 1/4/24.
//

import Foundation
import XUI

final class Contact: Contactable {
    let id: String
    let name: String
    let phoneNumber: String
    let photoUrl: String
    let pushToken: String
    
    required init(id: String, name: String, phoneNumber: String, photoUrl: String, pushToken: String) {
        self.id = id
        self.name = name
        self.phoneNumber = phoneNumber
        self.photoUrl = photoUrl
        self.pushToken = pushToken
    }
    static var currentUser: Contact = Contact(id: "2", name: "Jonah Aung", phoneNumber: "88585229", photoUrl: "https://avatars.githubusercontent.com/u/108913030?v=4", pushToken: "lklk")
}

extension Contact {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    static func == (lhs: Contact, rhs: Contact) -> Bool {
        lhs.id == rhs.id
    }
}
