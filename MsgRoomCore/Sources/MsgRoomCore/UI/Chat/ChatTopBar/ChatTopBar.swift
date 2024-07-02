//
//  ChatTopBar.swift
//  Msgr
//
//  Created by Aung Ko Min on 22/10/22.
//

import SwiftUI
import XUI

struct ChatTopBar<Msg: MsgRepresentable, Room: RoomRepresentable, Contact: ContactRepresentable>: View {
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var viewModel: MsgRoomViewModel<Msg, Room, Contact>
    @Injected(\.incomingSocket) private var incomingSocket
    
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            HStack(alignment: .center) {
                AsyncButton {
                    viewModel.datasource.updateLastMsg()
                } label: {
                    SystemImage(.chevronLeft)
                        .bold()
                        .imageScale(.large)
                } onFinish: {
                    dismiss()
                }
                BadegAvatarView(urlString: viewModel.datasource.room.photoURL ?? "", size: 35)
                Spacer()
                VStack(spacing: 0) {
                    Text(viewModel.datasource.room.name)
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                    Text("28 mins ago")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                AsyncButton {
                    switch viewModel.datasource.room.type {
                    case .group:
                        let contact: Contact? = viewModel.datasource.room.contacts.random() as? Contact
                        if let contact {
                            if let msg = try await Msg.create(conId: viewModel.datasource.room.id, date: .now, id: UUID().uuidString, deliveryStatus: .Received, msgType: .Text, senderId: contact.id, text: Lorem.random) {
                                await incomingSocket.receive(.newMsg(msg))
                            }
                        }
                    case .single:
                        let contact: Contact? = viewModel.datasource.room.contacts.first as? Contact
                        if let contact {
                            if let msg = try await Msg.create(conId: viewModel.datasource.room.id, date: .now, id: UUID().uuidString, deliveryStatus: .Received, msgType: .Text, senderId: contact.id, text: Lorem.random) {
                                await incomingSocket.receive(.newMsg(msg))
                            }
                        }
                    }
                } label: {
                    SystemImage(.quoteClosing, 28)
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 10)
            .background(.bar)
        }
    }
}
