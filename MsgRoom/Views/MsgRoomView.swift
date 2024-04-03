//
//  MsgRoomView.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 12/3/24.
//

import SwiftUI
import XUI

struct MsgRoomView<MsgItem: Msgable, ConItem: Conversationable>: View {
    
    @EnvironmentObject private var viewModel: MsgRoomViewModel<MsgItem, ConItem>
    
    var body: some View {
        VStack(spacing: 0) {
            ChatTopBar<MsgItem, ConItem>()
            ChatScrollView<MsgItem, ConItem>()
                .overlay(ScrollDownButton(), alignment: .bottomTrailing)
            ChatInputBar<MsgItem, ConItem>()
        }
        .background(ChatBackground().ignoresSafeArea(.all))
        .accentColor(viewModel.con.themeColor.color)
        .environmentObject(viewModel)
        .navigationBarHidden(true)
    }
}
