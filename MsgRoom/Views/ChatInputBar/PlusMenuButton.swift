//
//  LeftMenuButton.swift
//  Conversation
//
//  Created by Aung Ko Min on 31/1/22.
//

import SwiftUI

struct PlusMenuButton: View {
    
    @EnvironmentObject private var viewModel: MsgRoomViewModel<Msg>
    
    var body: some View {
        Button {
            viewModel.datasource.allMsgs.forEach{( $0.deliveryStatus = .Read )}
            
        } label: {
            Image(systemName: "camera.macro")
                .resizable()
                .frame(width: 25, height: 25)
                .padding(4)
        }
    }
}
