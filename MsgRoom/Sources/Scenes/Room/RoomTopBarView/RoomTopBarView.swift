//
//  ChatTopBar.swift
//  Msgr
//
//  Created by Aung Ko Min on 22/10/22.
//

import SwiftUI
import XUI

struct RoomTopBarView: View {
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var viewModel: RoomViewModel
    @Injected(\.incomingSocket) private var incomingSocket
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            HStack(alignment: .center) {
                AsyncButton {
                    dismiss()
                } label: {
                    SystemImage(.chevronLeft)
                        .bold()
                        .imageScale(.large)
                } onFinish: {
                    dismiss()
                }
                Spacer()
//                BadegAvatarView(urlString: viewModel.datasource.room.photoURL ?? "", size: 35)
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
                        @Injected(\.swiftdataRepo) var repo
                        let contact: Contact? = viewModel.datasource.room.contacts.random()
                        if let contact {
                            let msg = Msg(roomID: viewModel.datasource.room.id, senderID: contact.id, msgKind: .Text, text: Lorem.random)
                            @Injected(\.swiftdataRepo) var repo
                            switch await repo.create(msg) {
                            case .success(let msg):
                                @Injected(\.incomingSocket) var socket
                                await socket.receive(.newMsg(msg))
                            case .failure(let error):
                                Log(error)
                            }
                            
                        }
                    case .single:
                        let contact: Contact? = viewModel.datasource.room.contacts.first
                        if let contact {
                            let msg = Msg(roomID: viewModel.datasource.room.id, senderID: [contact.id, CurrentUser.current.id].random()!, msgKind: .Text, text: Lorem.random)
                            @Injected(\.swiftdataRepo) var repo
                            switch await repo.create(msg) {
                            case .success(let msg):
                                viewModel.interactor.sendAction(.init(item: .sendMsg(.msg(msg))))
                            case .failure(let error):
                                Log(error)
                            }
                        }
                    }
                } label: {
                    SystemImage(.quoteClosing, 28)
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 6)
            .background(Color.Shadow.main)
            Divider()
                .foregroundStyle(.quinary)
        }
    }
}
