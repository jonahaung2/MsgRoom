//
//  SendButton.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 26/6/24.
//

import SwiftUI
import XUI

struct SendButton: View {
    
    @StateObject private var chatInputBarviewModel = ChatInputBarViewModel()
    
    var sendMessage: @Sendable () async throws -> Void
    
    var body: some View {
        AsyncButton {
            try await sendMessage()
        } label: {
            Group {
                if chatInputBarviewModel.text.isWhitespace && chatInputBarviewModel.itemType == .text {
                    SystemImage(.heartFill, 32)
                } else {
                    SystemImage(.chevronUpCircleFill, 44)
                        .imageScale(.large)
                }
            }
            .transition(.scale)
            .symbolRenderingMode(.multicolor)
        }
        .contentTransition(.symbolEffect(.replace))
        .fontWeight(.light)
        .animation(.interactiveSpring(duration: 0.5, extraBounce: 0.3), value: chatInputBarviewModel.text.isEmpty)
    }
}
