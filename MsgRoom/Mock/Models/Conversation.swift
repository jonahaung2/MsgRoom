//
//  Con.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 1/4/24.
//

import SwiftUI
import XUI
import SwiftData

@Model
final class Conversation: ConversationRepresentable {
    
    @Attribute(.unique) var id: String
    var name: String
    var type: ConversationType
    var createdDate: Date
    var photoUrl: String
    
    required init(id: String, date: Date, name: String, photoUrl: String, type: ConversationType) {
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
        case .single:
            (0...500).forEach { each in
                let msg = Item(conId: id, date: .now, id: each.description, deliveryStatus: .Read, msgType: .Text, senderId: [Contact.currentUser.id, UUID().uuidString].random()!, text: Lorem.random)
                values.append(msg)
            }
        case .group:
            (0...500).forEach { each in
                let msg = Item(conId: id, date: .now, id: each.description, deliveryStatus: .Read, msgType: .Text, senderId: UUID().uuidString, text: Lorem.random)
                values.append(msg)
            }
        }
        return values
    }
}
