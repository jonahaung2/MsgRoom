//
//  MsgRoomView.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 12/3/24.
//

import SwiftUI
import XUI
import SwiftData
import MsgRoomCore
struct MsgRoomView<Msg: MsgRepresentable, Room: RoomRepresentable, Contact: ContactRepresentable>: View {
    
    @StateObject var viewModel: MsgRoomViewModel<Msg, Room, Contact>
    @Injected(\.incomingSocket) private var incomingSocket
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ChatScrollView<Msg, Room, Contact>()
            .overlay(alignment: .bottom) {
                ScrollDownButton()
                    .animation(.snappy, value: viewModel.showScrollToLatestButton)
            }
            .safeAreaInset(edge: .top) {
                ChatTopBar<Msg, Room, Contact>()
            }
            .safeAreaInset(edge: .bottom) {
                ChatInputBar<Msg, Room, Contact>()
            }
            .environmentObject(viewModel)
            .toolbar(.hidden, for: .tabBar)
            .toolbar(.hidden, for: .navigationBar)
    }
}
