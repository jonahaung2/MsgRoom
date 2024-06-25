//
//  ConRepresentable.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 12/3/24.
//

import SwiftUI
import XUI

protocol ConversationRepresentable: Comformable {
    
    var id: String { get }
    var name: String { get }
    var type: ConversationType { get }
    var createdDate: Date { get }
    var photoUrl: String { get }
    
    init(id: String, date: Date, name: String, photoUrl: String, type: ConversationType)
    func msgs<Item: MessageRepresentable>() -> [Item]
}

extension ConversationRepresentable {
    var nameX: String {
        switch type {
        case .single(let x):
            return x
        case .group(let mbrs):
            return "\(name) \(mbrs.count)"
        }
    }
    func bubbleColor(for msg: any MessageRepresentable) -> Color {
        msg.recieptType == .Send ?
        Color.accentColor
        :
        Color(.secondarySystemBackground)
    }
}
