//
//  ConRepresentable.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 12/3/24.
//

import SwiftUI
import XUI
import SwiftData

protocol Conversation_: Conformable {
    var id: String { get }
    var name: String { get set }
    var type: ConversationType { get }
    var createdDate: Date { get }
    var photoURL: String? { get set }
    
    static func create(id: String, date: Date, name: String, photoUrl: String, type: ConversationType) async throws -> (any Conversation_)?
}

extension Conversation_ {
    var nameX: String {
        name
    }
    func bubbleColor(for msg: any Msg_) -> Color {
        msg.recieptType == .Send ?
        Color.accentColor
        :
        Color(uiColor: .tertiarySystemFill).opacity(1)
    }
}
