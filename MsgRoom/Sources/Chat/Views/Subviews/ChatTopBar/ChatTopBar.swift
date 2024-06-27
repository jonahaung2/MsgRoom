//
//  ChatTopBar.swift
//  Msgr
//
//  Created by Aung Ko Min on 22/10/22.
//

import SwiftUI
import XUI

struct ChatTopBar<Msg: MessageRepresentable, Con: ConversationRepresentable>: View {
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var viewModel: MsgRoomViewModel<Msg, Con>
    @Injected(\.incomingSocket) private var incomingSocket
    
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            HStack(alignment: .center) {
                Button {
                    dismiss()
                } label: {
                    SystemImage(.chevronLeft)
                        .bold()
                        .imageScale(.large)
                        .padding(.horizontal)
                        .padding(.bottom, 5)
                }
                
                Spacer()
                
                VStack(spacing: 0) {
                    Text(viewModel.datasource.con.name)
                        .font(.footnote)
                }
                Spacer()
                AsyncButton {
                    switch viewModel.datasource.con.type {
                    case .group:
                        let msg = Msg(conId: viewModel.datasource.con.id, date: .now, id: UUID().uuidString, deliveryStatus: .Received, msgType: .Text, senderId: UUID().uuidString, text: Lorem.random)
                        await incomingSocket.receive(.newMsg(msg))
                    case .single:
                        let msg = Msg(conId: viewModel.datasource.con.id, date: .now, id: UUID().uuidString, deliveryStatus: .Received, msgType: .Text, senderId: UUID().uuidString, text: Lorem.random)
                        await incomingSocket.receive(.newMsg(msg))
                    }
                } label: {
                    SystemImage(.quoteClosing, 32)
                }
            }
            .padding(.horizontal)
            .background(.bar)
        }
    }
}
