//
//  SendButton.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 26/6/24.
//

import SwiftUI
import XUI

struct SendButton: View {
    
    @EnvironmentObject private var chatInputBarviewModel: ChatInputBarViewModel
    
    var sendMessage: @Sendable () async throws -> Void
    
    var body: some View {
        AsyncButton {
            try await sendMessage()
        } label: {
            Group {
                if chatInputBarviewModel.itemType == .text {
                    if chatInputBarviewModel.text.isWhitespace {
                        SystemImage(.micFillBadgePlus, 32)
                    } else {
                        SystemImage(.arrowUpCircleFill, 38)
                    }
                } else {
                    SystemImage(.chevronUpCircleFill, 35)
                }
            }
        }
        .contentTransition(.symbolEffect(.replace.wholeSymbol))
        .animation(.easeInOut, value: chatInputBarviewModel.text.isEmpty)
    }
}
