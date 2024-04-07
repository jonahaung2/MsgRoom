//
//  RoomTheme.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 6/4/24.
//

import SwiftUI

enum ConversationThemeType: Int, CaseIterable, Identifiable, Codable {
    var id: Int { rawValue }
    case Blue, Orange, Yellow, Green, Mint, Teal, Cyan, Red, Indigo, Purple, Pink, Brown, Gray
    var name: String { "\(self)" }
    var color: Color {
        switch self {
        case .Blue:
            return .blue
        case .Orange:
            return .orange
        case .Yellow:
            return .yellow
        case .Green:
            return .green
        case .Mint:
            return .mint
        case .Teal:
            return .teal
        case .Cyan:
            return .cyan
        case .Red:
            return .red
        case .Indigo:
            return .indigo
        case .Purple:
            return .purple
        case .Pink:
            return .pink
        case .Brown:
            return .brown
        case .Gray:
            return .gray
        }
    }
}
