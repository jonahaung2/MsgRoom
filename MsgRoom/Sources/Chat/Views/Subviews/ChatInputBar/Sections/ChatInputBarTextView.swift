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
    
    var body: some View {
        HStack(alignment: .bottom) {
            AsyncButton {
                chatInputBarviewModel.itemType = chatInputBarviewModel.itemType == .photoPicker ? .none : .photoPicker
            } label: {
                if chatInputBarviewModel.itemType == .photoPicker {
                    SystemImage(.xmarkCircleFill, 32)
                } else {
                    SystemImage(.rectangleOnRectangleAngled, 32)
                }
            }
            .contentTransition(.symbolEffect(.replace))
            .animation(.default, value: chatInputBarviewModel.itemType)
            
            ZStack {
                TextField("Text..", text: $chatInputBarviewModel.text, axis: .vertical)
                    .lineLimit(1...10)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 7)
            .background (
                Color(uiColor: .quaternarySystemFill), in: RoundedRectangle(cornerRadius: 15)
            )
            .highPriorityGesture(
                TapGesture().onEnded({ _ in
                    _Haptics.play(.light)
                    chatInputBarviewModel.textViewisFocusing = true
                })
            )
            SendButton {
                try await sendMessage()
            }
        }
        .padding(5)
        .padding(.horizontal, 7)
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
