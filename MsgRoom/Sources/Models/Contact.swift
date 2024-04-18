//
//  Contact.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 1/4/24.
//

import Foundation

struct Contact: Codable, Identifiable, Hashable {
    let id: String
    var name: String
    var phoneNumber: String
    var photoUrl: String
    var pushToken: String
    static var currentUser: Contact { Contact(id: "jonahaung@gmail.com", name: "Aung Ko Min", phoneNumber: "88595229", photoUrl: "", pushToken: "")}
}
