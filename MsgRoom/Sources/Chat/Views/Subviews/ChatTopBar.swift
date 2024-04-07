//
//  ChatTopBar.swift
//  Msgr
//
//  Created by Aung Ko Min on 22/10/22.
//

import SwiftUI
import XUI
import Symbols

struct ChatTopBar<MsgItem: MessageRepresentable, ConItem: ConversationRepresentable>: View {
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var viewModel: MsgRoomViewModel<MsgItem, ConItem>

    var body: some View {
        VStack {
            HStack(alignment: .top) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .bold()
                        .imageScale(.large)
                        .padding(.horizontal)
                        .padding(.bottom, 5)
                }

                Spacer()

                VStack(spacing: 0) {
                    Text(viewModel.con.nameX)
                        .font(.subheadline)
                        .foregroundColor(.primary)
//                        .tapToPush(ConInfoView().environmentObject(viewModel))
                }

                Spacer()


                Button {
                    viewModel.isTyping.toggle()
                } label: {
                    Image(systemName: "video.fill")
                        .imageScale(.large)
                        .padding(.bottom, 5)
                }
                Button {
                    switch viewModel.con.roomType {
                    case .group(let members):
                        let msg = MsgItem(conId: viewModel.con.id, date: .now, id: UUID().uuidString, deliveryStatus: .Received, msgType: .Text, sender: members.randomElement()!, text: Lorem.random)
                        LocalNotifications.postMsg(payload: msg)
                    case .single(let contact):
                        let msg = MsgItem(conId: viewModel.con.id, date: .now, id: UUID().uuidString, deliveryStatus: .Received, msgType: .Text, sender: contact, text: Lorem.random)
                        LocalNotifications.postMsg(payload: msg)
                    }
                    
                } label: {
                    Image(systemName: "tuningfork")
                        .imageScale(.large)
                        .padding(.trailing)
                        .padding(.bottom, 5)
                }
            }
            Divider()
        }
        .background()
    }
}
