//
//  MsgRoomView.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 12/3/24.
//

import SwiftUI
import XUI

struct MsgRoomView<MsgItem: Msgable>: View {
    
    @StateObject private var viewModel: MsgRoomViewModel<MsgItem>
    
    init(_con: any Conversationable) {
        _viewModel = .init(wrappedValue: .init(_con: _con))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ChatTopBar<MsgItem>()
            ChatScrollView<MsgItem>()
                .overlay(ScrollDownButton(), alignment: .bottomTrailing)
            ChatInputBar<MsgItem>()
        }
        .background(ChatBackground().ignoresSafeArea(.all))
        .accentColor(viewModel.con.themeColor.color)
        .environmentObject(viewModel)
        .navigationBarHidden(true)
    }
}
