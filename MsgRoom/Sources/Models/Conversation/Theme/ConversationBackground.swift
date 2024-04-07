//
//  RoomBgImage.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 6/4/24.
//

import SwiftUI
enum ConversationBackground: Int, CaseIterable, Identifiable, Codable {
    var id: Int { rawValue }
    case None, One, White, Blue, Brown
    var name: String { "chatBg\(rawValue)" }
    var image: some View {
        Group {
            if self != .None {
                Image(name)
                    .resizable()
                    .clipped()
            } else {
                ChatBackground()
            }
        }
    }
}
