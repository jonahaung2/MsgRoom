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
                .animation(.easeOut(duration: 0.15), value: viewModel.datasource.updater)
                .animation(.interactiveSpring, value: viewModel.settings.selectedId)
                .overlay(ChatTopBar<Msg>(), alignment: .top)
                .overlay(ScrollDownButton().animation(.bouncy, value: viewModel.settings.showScrollToLatestButton), alignment: .bottomTrailing)
            Divider()
            ChatInputBar<Msg>()
                .background(.ultraThickMaterial)
        }
        .background(
            ConversationTheme(type: .Blue, background: .Brown).background.image
        )
        .navigationBarHidden(true)
        .environmentObject(viewModel)
    }
}
