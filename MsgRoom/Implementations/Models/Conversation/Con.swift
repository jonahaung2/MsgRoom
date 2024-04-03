//
//  Con.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 1/4/24.
//

import SwiftUI
import XUI

final class Con: Conversationable {
    
    let id: String
    var bgImage_: Int16
    var bubbleCornorRadius: Int16
    let date: Date
    var name: String
    var photoUrl: String
    var themeColor_: Int16
    var members: [ContactItem]
    
    init(id: String, bgImage_: Int16, bubbleCornorRadius: Int16, date: Date, name: String, photoUrl: String, themeColor_: Int16, members: [ContactItem]) {
        self.id = id
        self.bgImage_ = bgImage_
        self.bubbleCornorRadius = bubbleCornorRadius
        self.date = date
        self.name = name
        self.photoUrl = photoUrl
        self.themeColor_ = themeColor_
        self.members = members
    }
    
//    func members<Item>() -> [Item] where Item : Contactable {
//        var values = [Item]()
//        (0...500).forEach { each in
//            let msg = Item(id: each.description, name: Lorem.fullName, phoneNumber: Lorem.emailAddress, photoUrl: Lorem.url, pushToken: Lorem.random)
//            values.append(msg)
//        }
//        return values
//    }
    func msgs<Item>() -> [Item] where Item : Msgable {
        var values = [Item]()
        (0...500).forEach { each in
            let msg = Item(conId: id, date: .now, id: each.description, deliveryStatus: .allCases.random()!, msgType: .Text, progress: 0, sender: members.random()!, text: Lorem.random)
            values.append(msg)
        }
        return values
    }
}
extension Con {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    static func == (lhs: Con, rhs: Con) -> Bool {
        lhs.id == rhs.id
    }
}
