//
//  MsgRoomView.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 12/3/24.
//

import SwiftUI
import XUI
import SwiftData

struct MsgRoomView<Msg: Msg_, Con: Conversation_>: View {
    
    @StateObject var viewModel: MsgRoomViewModel<Msg, Con>
    
    var body: some View {
        ChatScrollView<Msg, Con>()
            .animation(.interactiveSpring(duration: 0.3, extraBounce: 0.3, blendDuration: 0.4), value: viewModel.change)
            .overlay(alignment: .bottomTrailing) {
                ScrollDownButton()
                    .animation(.bouncy, value: viewModel.settings.showScrollToLatestButton)
            }
            .safeAreaInset(edge: .top) {
                ChatTopBar<Msg, Con>()
                
            }
            .safeAreaInset(edge: .bottom) {
                ChatInputBar<Msg, Con>()
                
            }
            .environmentObject(viewModel)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(.hidden, for: .navigationBar)
            .toolbar(.hidden, for: .tabBar)
    }
}
