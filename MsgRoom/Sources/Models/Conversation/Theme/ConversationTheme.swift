//
//  ConversationTheme.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 7/4/24.
//

import Foundation

struct ConversationTheme: Hashable, Codable, Identifiable {
    var id: String { "\(type.rawValue)\(background.rawValue)"}
    let type: ConversationThemeType
    let background: ConversationBackground
}
