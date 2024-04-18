//
//  MsgRoomView.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 12/3/24.
//

import SwiftUI
import XUI

struct MsgRoomView<Msg: MsgKind, Con: ConKind>: View {
    @StateObject var viewModel: MsgRoomViewModel<Msg, Con>
    var body: some View {
        VStack(spacing: 0) {
            ChatScrollView<Msg, Con>()
                .overlay(ChatTopBar<Msg, Con>(), alignment: .top)
                .overlay(ScrollDownButton<Msg, Con>(), alignment: .bottomTrailing)
            Divider()
            ChatInputBar<Msg, Con>()
                .background(.ultraThickMaterial)
        }
        .background(
            FloatingClouds()
        )
        .navigationBarHidden(true)
        .environmentObject(viewModel)
    }
}
