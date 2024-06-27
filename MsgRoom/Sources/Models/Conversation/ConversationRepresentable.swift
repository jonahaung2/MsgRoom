//
//  ConRepresentable.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 12/3/24.
//

import SwiftUI
import XUI

protocol ConversationRepresentable: Conformable {
    
    var id: String { get set }
    var name: String { get set }
    var type: ConversationType { get set }
    var createdDate: Date { get set }
    var photoUrl: String { get set }
    
    init(id: String, date: Date, name: String, photoUrl: String, type: ConversationType)
    func msgs<Item: MessageRepresentable>() -> [Item]
}

extension ConversationRepresentable {
    var nameX: String {
        name
    }
    func bubbleColor(for msg: any MessageRepresentable) -> Color {
        msg.recieptType == .Send ?
        Color.accentColor
        :
        Color(uiColor: .tertiarySystemFill).opacity(1)
    }
}
