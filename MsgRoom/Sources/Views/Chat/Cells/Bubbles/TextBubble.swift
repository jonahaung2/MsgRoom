//
//  TextBubble.swift
//  Conversation
//
//  Created by Aung Ko Min on 31/1/22.
//

import SwiftUI

struct TextBubble: View {
    let text: String
    var body: some View {
        Text(.init(text))
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .equatable(by: text)
    }
}
