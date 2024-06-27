//
//  ChatInputBarTextView.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 26/6/24.
//

import SwiftUI
import XUI

struct ChatInputBarTextView<Msg: MessageRepresentable, Con: ConversationRepresentable>: View {
    
    @EnvironmentObject private var chatInputBarviewModel: ChatInputBarViewModel
    @EnvironmentObject private var viewModel: MsgRoomViewModel<Msg, Con>
    @FocusState private var textViewIsFocused
    
    var body: some View {
        HStack(alignment: .bottom) {
            AsyncButton {
                chatInputBarviewModel.itemType = chatInputBarviewModel.itemType == .photoPicker ? .text : .photoPicker
            } label: {
                if chatInputBarviewModel.itemType == .photoPicker {
                    SystemImage(.xmarkCircleFill, 32)
                } else {
                    if textViewIsFocused {
                        SystemImage(.keyboardChevronCompactDown, 22)
                    } else {
                        SystemImage(.init(rawValue: "photo.badge.plus"), 32)
                    }
                }
            }
            TextField("Text..(↗)", text: $chatInputBarviewModel.text, axis: .vertical)
                .focused($textViewIsFocused)
                .fontDesign(.rounded)
                .lineLimit(1...10)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background()
                .overlay (
                    RoundedRectangle(cornerRadius: 15, style: .circular).stroke(.quaternary , style: .init(lineWidth: 1), antialiased: true)
                )
            SendButton {
                try await sendMessage()
            }
        }
        .padding(.horizontal, 10)
        .padding(.bottom, 4)
        .overlay(alignment: .top) {
            if textViewIsFocused {
                let value = chatInputBarviewModel.sentimentValue
                Circle().fill(value < 0 ? value < -0.5 ? Color.red: .orange : value > 0.5 ? .green : .blue)
                    .frame(square: 10)
                    .offset(x: value, y: -5)
                    .animation(.default, value: value)
            }
        }
        .equatable(by: chatInputBarviewModel.text)
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
        let msg = Msg(conId: viewModel.datasource.con.id, date: .now, id: UUID().uuidString, deliveryStatus: .Sending, msgType: .Text, senderId: Contact.currentUser.id, text: string)
        
        try await chatInputBarviewModel.outgoingSocket.sent(.newMsg(msg))
    }
}
