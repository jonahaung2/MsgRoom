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
        AsyncButton(actionOptions: []) {
            try await sendMessage()
        } label: {
            Group {
                if chatInputBarviewModel.itemType == .text {
                    SystemImage(chatInputBarviewModel.text.isWhitespace ? .micFill : .arrowUpCircleFill, 32)
                        .contentTransition(.symbolEffect(.replace))
                } else {
                    SystemImage(.arrowUpCircleFill, 35)
                }
            }
        }
    }
}
