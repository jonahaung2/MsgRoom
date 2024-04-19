//
//  MsgRoomView.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 12/3/24.
//

import SwiftUI
import XUI

struct MsgRoomView<Msg: MessageRepresentable>: View {
    @StateObject var viewModel: MsgRoomViewModel<Message>
    var body: some View {
        VStack(spacing: 0) {
            ChatScrollView<Msg>()
                .animation(.interactiveSpring, value: viewModel.selectedId)
                .overlay(ChatTopBar<Msg>(), alignment: .top)
                .overlay(ScrollDownButton(), alignment: .bottomTrailing)
            
            Divider()
            ChatInputBar<Msg>()
                .background(.ultraThickMaterial)
        }
        .background(
            ConversationTheme(type: .Blue, background: .None).background.image
        )
        .navigationBarHidden(true)
        .environmentObject(viewModel)
    }
}
