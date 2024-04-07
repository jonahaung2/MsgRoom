//
//  ConRepresentable.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 12/3/24.
//

import SwiftUI
import XUI
protocol ConversationRepresentable: AnyObject, Hashable, Observable, Identifiable {
    associatedtype ContactItem = Contactable
    var id: String { get }
    var name: String { get }
    var roomType: ConversationType { get }
    var createdDate: Date { get }
    var photoUrl: String { get }
    var theme: ConversationTheme { get set }
    
    init(id: String, bgImage: ConversationBackground, date: Date, name: String, photoUrl: String, theme: ConversationTheme, roomType: ConversationType)
    func msgs<Item: MessageRepresentable>() -> [Item]
}
extension ConversationRepresentable {
    var nameX: String {
        switch roomType {
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
