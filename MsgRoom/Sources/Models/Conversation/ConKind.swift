//
//  ConRepresentable.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 12/3/24.
//

import SwiftUI
import XUI

protocol ConKind: AnyObject, Observable, Hashable, Identifiable, Sendable {
    
    var id: String { get }
    var name: String { get set }
    var roomType: ConversationType { get set }
    var createdDate: Date { get set }
    var photoUrl: String { get set }
    var theme: ConversationTheme { get set }
    
    init(id: String, bgImage: ConversationBackground, date: Date, name: String, photoUrl: String, theme: ConversationTheme, roomType: ConversationType)
    func msgs<Item: MsgKind>() -> [Item]
}

extension ConKind {
    var nameX: String {
        switch roomType {
        case .single(let x):
            return x.name
        case .group(let mbrs):
            return "\(name) \(mbrs.count)"
        }
    }
    func bubbleColor(for msg: any MsgKind) -> Color {
        msg.recieptType == .Send ?
        theme.type.color
        :
        Color(.secondarySystemBackground)
    }
}
