//
//  ChatInputBar.swift
//  Msgr
//
//  Created by Aung Ko Min on 21/10/22.
//

import SwiftUI
import XUI

struct ChatInputBar<Msg: MsgKind, Con: ConKind>: View {
    
    @EnvironmentObject private var viewModel: MsgRoomViewModel<Msg, Con>
    @State private var text = ""
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .bottom) {
                PlusMenuButton<Msg, Con>()
                TextField("Text..", text: $text, axis: .vertical)
                    .lineLimit(1...10)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 7)
                    .background (
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color(uiColor: .separator), lineWidth: 1)
                    )
                
                Button(action: action) {
                    if text.isWhitespace {
                        Image(systemName: "hand.thumbsup.fill")
                            .resizable()
                            .transition(.scale(scale: 0.1))
                    } else {
                        Image(systemName: "chevron.up.circle.fill")
                            .resizable()
                            .transition(.scale(scale: 0.1))
                    }
                }
                .frame(width: 35, height: 35)
                .padding(5)
            }
            .padding(.vertical, 5)
            .padding(.horizontal)
        }
    }
    
    private func action() {
        if text.isWhitespace {
            withAnimation(.interactiveSpring()) {
                text = Lorem.random
            }
            return
        }
        let sendText = text
        text.removeAll()
        
        let msg = Msg(conId: viewModel.con.id, date: .now, id: UUID().uuidString, deliveryStatus: .Sending, msgType: .Text, sender: Contact.currentUser, text: sendText)
        Socket.shared.postMsg(.init(type: .New(item: msg)))
    }
}
