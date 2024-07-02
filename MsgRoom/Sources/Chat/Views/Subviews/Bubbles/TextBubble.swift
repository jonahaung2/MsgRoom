//
//  TextBubble.swift
//  Conversation
//
//  Created by Aung Ko Min on 31/1/22.
//

import SwiftUI
import MsgRoomCore

struct TextBubble: View {
    let style: MsgCellPresenter
    let text: String
    var body: some View {
        Text(text)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
    }
}
