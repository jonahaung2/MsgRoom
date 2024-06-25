//
//  Con.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 1/4/24.
//

import SwiftUI
import XUI

struct Conversation: ConversationRepresentable {
    
    let id: String
    let name: String
    let type: ConversationType
    let createdDate: Date
    let photoUrl: String
    
    init(id: String, date: Date, name: String, photoUrl: String, type: ConversationType) {
        self.id = id
        self.createdDate = date
        self.name = name
        self.photoUrl = photoUrl
        self.type = type
    }
}

extension Conversation {
    func msgs<Item>() -> [Item] where Item : MessageRepresentable {
        var values = [Item]()
        switch type {
        case .single(let contact):
            (0...500).forEach { each in
                let msg = Item(conId: id, date: .now, id: each.description, deliveryStatus: .Read, msgType: .Text, senderId: [Contact.currentUser.id, contact.id].random()!, text: Lorem.random)
                values.append(msg)
            }
        case .group(let contacts):
            (0...500).forEach { each in
                let msg = Item(conId: id, date: .now, id: each.description, deliveryStatus: .Read, msgType: .Text, senderId: contacts.random()!, text: Lorem.random)
                values.append(msg)
            }
        }
        return values
    }
}
