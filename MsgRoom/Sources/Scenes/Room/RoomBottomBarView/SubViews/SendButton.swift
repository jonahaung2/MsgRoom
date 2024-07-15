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
            SystemImage(.arrowUpCircleFill, 37)
        }
    }
}
