//
//  ConRepresentable.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 12/3/24.
//

import SwiftUI
import XUI

protocol ConversationRepresentable: AnyObject, Observable, Hashable, Identifiable, Sendable {
    
    associatedtype ContactItem = ContactRepresentable
    
    var id: String { get }
    var name: String { get set }
    var type: ConversationType { get set }
    var createdDate: Date { get set }
    var photoUrl: String { get set }
    var theme: ConversationTheme { get set }
    
    init(id: String, date: Date, name: String, photoUrl: String, theme: ConversationTheme, type: ConversationType)
    func msgs<Item: MessageRepresentable>() -> [Item]
}

extension ConversationRepresentable {
    var nameX: String {
        switch type {
        case .single(let x):
            return x.name
        case .group(let mbrs):
            return "\(name) \(mbrs.count)"
        }
    }
    func bubbleColor(for msg: any MessageRepresentable) -> Color {
        msg.recieptType == .Send ?
        theme.type.color
        :
        Color(.secondarySystemBackground)
    }
}
