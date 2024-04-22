//
//  ChatTopBar.swift
//  Msgr
//
//  Created by Aung Ko Min on 22/10/22.
//

import SwiftUI
import XUI
import MsgrCore

struct ChatTopBar<MsgItem: MessageRepresentable>: View {
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var viewModel: MsgRoomViewModel<MsgItem>
    
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
                    Text(viewModel.datasource.con.nameX)
                        .font(.footnote)
                }
                Spacer()
                Button {
                    switch viewModel.datasource.con.type {
                    case .group(let members):
                        let msg = MsgItem(conId: viewModel.datasource.con.id, date: .now, id: UUID().uuidString, deliveryStatus: .Received, msgType: .Text, sender: members.filter{ !$0.isCurrentUser }.randomElement()!, text: Lorem.random)
                        Socket.shared.receiveIncoming(.newMsg(msg))
                    case .single(let contact):
                        let msg = MsgItem(conId: viewModel.datasource.con.id, date: .now, id: UUID().uuidString, deliveryStatus: .Received, msgType: .Text, sender: contact, text: Lorem.random)
                        Socket.shared.receiveIncoming(.newMsg(msg))
                    }
                } label: {
                    SystemImage(.messageFill)
                        .imageScale(.large)
                        .padding(.trailing)
                        .padding(.bottom, 5)
                }
            }
            .background(.ultraThickMaterial)
            Divider()
            HStack {
                Text(Date.now.formatted(date: .omitted, time: .shortened))
                    .font(.caption.bold())
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background()
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.top, 5)
            }
        }
    }
}
