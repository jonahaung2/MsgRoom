//
//  CellProgressView.swift
//  Conversation
//
//  Created by Aung Ko Min on 17/2/22.
//

import SwiftUI
import MsgRoomCore

struct CellProgressView: View {
    
    let progress: MsgDelivery
    
    var body: some View {
        if let iconName = progress.iconName() {
            Image(systemName: iconName)
                .imageScale(.small)
//                    .resizable()
//                    .scaledToFit()
                .foregroundStyle(.tertiary)
        }
    }
}
