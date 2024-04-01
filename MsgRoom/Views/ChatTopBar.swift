//
//  ChatTopBar.swift
//  Msgr
//
//  Created by Aung Ko Min on 22/10/22.
//

import SwiftUI

struct ChatTopBar<MsgItem: Msgable>: View {
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var viewModel: MsgRoomViewModel<MsgItem>

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

                } label: {
                    Image(systemName: "phone.fill")
                        .imageScale(.large)
                        .padding(.bottom, 5)
                }
                Button {
                    viewModel.isTyping.toggle()
                } label: {
                    Image(systemName: "video.fill")
                        .imageScale(.large)
                        .padding(.bottom, 5)
                }
                Button {
                    viewModel.simulateDemoMsg()
                } label: {
                    Image(systemName: "tuningfork")
                        .imageScale(.large)
                        .padding(.trailing)
                        .padding(.bottom, 5)
                }
            }
        }.background()
    }
}
