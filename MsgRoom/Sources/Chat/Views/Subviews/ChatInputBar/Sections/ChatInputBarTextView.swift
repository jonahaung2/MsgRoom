//
//  ChatInputBarTextView.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 26/6/24.
//

import SwiftUI
import XUI

struct ChatInputBarTextView<Msg: MsgRepresentable, Room: RoomRepresentable, Contact: ContactRepresentable>: View {
    
    @EnvironmentObject private var chatInputBarviewModel: ChatInputBarViewModel
    @EnvironmentObject private var viewModel: MsgRoomViewModel<Msg, Room, Contact>
    @FocusState private var textViewIsFocused
    
    var body: some View {
        HStack(alignment: .bottom) {
            AsyncButton(actionOptions: []) {
                if chatInputBarviewModel.itemType == .photoPicker {
                    chatInputBarviewModel.itemType = .text
                } else {
                    if textViewIsFocused {
                        textViewIsFocused = false
                    } else {
                        chatInputBarviewModel.itemType = .photoPicker
                    }
                }
            } label: {
                Group {
                    if chatInputBarviewModel.itemType == .photoPicker {
                        SystemImage(.xmarkCircleFill, 32)
                    } else {
                        SystemImage(textViewIsFocused ? .keyboardChevronCompactDown : .rectangleOnRectangle, 32)
                            .contentTransition(.symbolEffect(.replace))
                    }
                }
            }
            TextField("Text..", text: $chatInputBarviewModel.text, axis: .vertical)
                .focused($textViewIsFocused)
                .fontDesign(.rounded)
                .lineLimit(1...10)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background {
                    RoundedRectangle(cornerRadius: 15, style: .continuous).stroke(.quaternary.opacity(1) , style: .init(lineWidth: 1), antialiased: true)
                }
                .compositingGroup()
            SendButton {
                try await sendMessage()
            }
        }
        .padding(.horizontal, 10)
        .padding(.bottom, 4)
//        .overlay(alignment: .top) {
//            if textViewIsFocused {
//                let value = chatInputBarviewModel.sentimentValue
//                Circle().fill(value < 0 ? value < -0.5 ? Color.red: .orange : value > 0.5 ? .green : .blue)
//                    .frame(square: 10)
//                    .offset(x: value, y: -5)
//                    .animation(.default, value: value)
//            }
//        }
    }
    
    private func sendMessage() async throws {
        let text = chatInputBarviewModel.text
        if text.isWhitespace {
            self.chatInputBarviewModel.text = Lorem.random
            return
        }
        let string = text
        withAnimation(.interactiveSpring) {
            chatInputBarviewModel.text.removeAll()
        }
        if let msg = try await Msg.create(conId: viewModel.datasource.room.id, date: .now, id: UUID().uuidString, deliveryStatus: .Sending, msgType: .Text, senderId: currentUserId, text: string) {
            try await chatInputBarviewModel.outgoingSocket.sent(.newMsg(msg))
        }

    }
}
