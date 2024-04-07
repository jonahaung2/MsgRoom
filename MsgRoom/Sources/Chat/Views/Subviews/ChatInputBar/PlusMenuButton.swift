//
//  LeftMenuButton.swift
//  Conversation
//
//  Created by Aung Ko Min on 31/1/22.
//

import SwiftUI
import XUI
import Symbols

struct PlusMenuButton: View {
    
    @EnvironmentObject private var viewModel: MsgRoomViewModel<Message, Conversation>
    
    var body: some View {
        Button {
            viewModel.datasource.msgs.forEach { each in
                each.deliveryStatus = .Read
            }
        } label: {
            Image(systemName: "camera.fill")
                .resizable()
                .frame(width: 50, height: 25)
                .padding(4)
        }
    }
}
