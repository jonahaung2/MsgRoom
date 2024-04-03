//
//  CurrentUser.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 1/4/24.
//

import Foundation

struct CurrentUser {
    static let id = UUID().uuidString
    static let contact: Contact = .init(id: id, name: "Jonah Aung", phoneNumber: "88585229", photoUrl: "https://avatars.githubusercontent.com/u/108913030?v=4", pushToken: "lklk")
}
