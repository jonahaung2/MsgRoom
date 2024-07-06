//
//  ScrollDownButton.swift
//  Msgr
//
//  Created by Aung Ko Min on 21/10/22.
//

import SwiftUI
import XUI

public struct ScrollDownButton<Msg: MsgRepresentable, Room: RoomRepresentable, Contact: ContactRepresentable>: View {
    
    @EnvironmentObject private var viewModel: MsgRoomViewModel<Msg, Room, Contact>
    
    public var body: some View {
        HStack {
            if viewModel.showScrollToLatestButton {
                Button {
                    didTapButton()
                } label: {
                    ZStack {
                        Circle().fill(.ultraThinMaterial)
                        SystemImage(.chevronDown)
                    }
                    .frame(square: 35)
                }
                .transition(.move(edge: .bottom).combined(with: .scale).animation(.interpolatingSpring))
                
            }
        }
    }
    @MainActor private func didTapButton() {
        viewModel.settings.scrollItem = nil
        viewModel.scrollToBottom(true)
    }
}
