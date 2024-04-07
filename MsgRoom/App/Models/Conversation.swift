//
//  Con.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 1/4/24.
//

import SwiftUI
import XUI

final class Conversation: ConversationRepresentable {
    
    let id: String
    var name: String
    var roomType: ConversationType
    let createdDate: Date
    var photoUrl: String
    var theme: ConversationTheme
    var background: ConversationBackground
    
    init(id: String, bgImage: ConversationBackground, date: Date, name: String, photoUrl: String, theme: ConversationTheme, roomType: ConversationType) {
        self.id = id
        self.background = bgImage
        self.createdDate = date
        self.name = name
        self.photoUrl = photoUrl
        self.theme = theme
        self.roomType = roomType
        self.theme = theme
    }
}
extension Conversation {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    static func == (lhs: Conversation, rhs: Conversation) -> Bool {
        lhs.id == rhs.id
    }
}

extension Conversation {
    func msgs<Item>() -> [Item] where Item : MessageRepresentable {
        var values = [Item]()
        switch roomType {
        case .single(let contact):
            (0...500).forEach { each in
                let msg = Item(conId: id, date: .now, id: each.description, deliveryStatus: .allCases.random()!, msgType: .Text, sender: [Contact.currentUser, contact].random()!, text: Lorem.random)
                values.append(msg)
            }
        case .group(let contacts):
            (0...500).forEach { each in
                let msg = Item(conId: id, date: .now, id: each.description, deliveryStatus: .allCases.random()!, msgType: .Text, sender: contacts.random()!, text: Lorem.random)
                values.append(msg)
            }
        }
        return values
    }
}
