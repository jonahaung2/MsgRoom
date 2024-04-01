//
//  Con.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 1/4/24.
//

import SwiftUI

final class Con: Conversationable {
    let id: String
    var bgImage_: Int16
    var bubbleCornorRadius: Int16
    let date: Date
    var name: String
    var photoUrl: String
    var themeColor_: Int16
    var members_: [String]
    
    required init(id: String, bgImage_: Int16, bubbleCornorRadius: Int16, date: Date, name: String, photoUrl: String, themeColor_: Int16, members_: [String]) {
        self.id = id
        self.bgImage_ = bgImage_
        self.bubbleCornorRadius = bubbleCornorRadius
        self.date = date
        self.name = name
        self.photoUrl = photoUrl
        self.themeColor_ = themeColor_
        self.members_ = members_
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
