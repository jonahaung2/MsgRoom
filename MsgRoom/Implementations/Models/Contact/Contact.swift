//
//  Contact.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 1/4/24.
//

import Foundation

class Contact: Contactable {
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
}

extension Contact {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    static func == (lhs: Contact, rhs: Contact) -> Bool {
        lhs.id == rhs.id
    }
}
extension Contact {
    struct Payload: Codable, Identifiable {
        let id: String
        let name: String
        let phone: String
        let photoURL: String?
        var pushToken: String?
    }
}

extension Contact.Payload {
    init(_ contact: Contact) {
        self.init(id: contact.id, name: contact.name, phone: contact.phoneNumber, photoURL: contact.photoUrl, pushToken: contact.pushToken)
    }
}
