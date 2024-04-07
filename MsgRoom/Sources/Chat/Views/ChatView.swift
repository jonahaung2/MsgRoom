//
//  MsgRoomView.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 12/3/24.
//

import SwiftUI
import XUI

struct MsgRoomView<MsgItem: MessageRepresentable, ConItem: ConversationRepresentable>: View {
    @StateObject var viewModel: MsgRoomViewModel<Message, Conversation>
    var body: some View {
        VStack(spacing: 0) {
            ChatScrollView<MsgItem, ConItem>()
                .overlay(ChatTopBar<MsgItem, ConItem>(), alignment: .top)
                .overlay(ScrollDownButton(), alignment: .bottomTrailing)
            Divider()
            ChatInputBar<MsgItem, ConItem>()
                .background(.ultraThickMaterial)
        }
        .background(
            Color(uiColor: .systemBackground).gradient
//            FloatingClouds()
        )
        .navigationBarHidden(true)
        .environmentObject(viewModel)
    }
}
