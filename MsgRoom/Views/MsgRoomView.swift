//
//  MsgRoomView.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 12/3/24.
//

import SwiftUI
import XUI

struct MsgRoomView<MsgItem: Msgable>: View {
    
    @EnvironmentObject private var viewModel: MsgRoomViewModel<MsgItem>
    
    var body: some View {
        VStack(spacing: 0) {
            ChatTopBar<MsgItem>()
            Divider()
            ChatScrollView<MsgItem>()
                .overlay(ScrollDownButton(), alignment: .bottomTrailing)
            Divider()
            ChatInputBar<MsgItem>()
        }
        .background(ChatBackground().ignoresSafeArea(.all))
        .accentColor(viewModel.con.themeColor.color)
        .environmentObject(viewModel)
        .navigationBarHidden(true)
    }
}
