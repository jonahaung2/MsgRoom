//
//  MsgRoomView.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 12/3/24.
//

import SwiftUI
import XUI
import SwiftData

struct MsgRoomView<Msg: MsgRepresentable, Room: RoomRepresentable, Contact: ContactRepresentable>: View {
    
    @StateObject var viewModel: MsgRoomViewModel<Msg, Room, Contact>
    @Injected(\.incomingSocket) private var incomingSocket
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ChatScrollView<Msg, Room, Contact>()
            .animation(.interactiveSpring(duration: 0.3, extraBounce: 0.3, blendDuration: 0.4), value: viewModel.change)
            .overlay(alignment: .bottomTrailing) {
                ScrollDownButton()
                    .animation(.bouncy, value: viewModel.settings.showScrollToLatestButton)
            }
            .safeAreaInset(edge: .bottom) {
                ChatInputBar<Msg, Room, Contact>()
                
            }
            .environmentObject(viewModel)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(.hidden, for: .tabBar)
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    AsyncButton {
                        switch viewModel.datasource.con.type {
                        case .group:
                            if let msg = try await Msg.create(conId: viewModel.datasource.con.id, date: .now, id: UUID().uuidString, deliveryStatus: .Received, msgType: .Text, senderId: viewModel.datasource.con.contacts.first?.id ?? "", text: Lorem.random) {
                                await incomingSocket.receive(.newMsg(msg))
                            }
                            break
                        case .single:
                            if let msg = try await Msg.create(conId: viewModel.datasource.con.id, date: .now, id: UUID().uuidString, deliveryStatus: .Received, msgType: .Text, senderId: viewModel.datasource.con.contacts.last?.id ?? currentUserId, text: Lorem.random) {
                                await incomingSocket.receive(.newMsg(msg))
                            }
                        }
                    } label: {
                        SystemImage(.quoteClosing, 32)
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        SystemImage(.chevronLeft)
                    }
                }
            }
    }
}
