//
//  ScrollDownButton.swift
//  Msgr
//
//  Created by Aung Ko Min on 21/10/22.
//

import SwiftUI
import XUI
struct ScrollDownButton: View {
    
    @EnvironmentObject private var viewModel: MsgRoomViewModel<Msg, Room, Contact>
    
    var body: some View {
        if viewModel.showScrollToLatestButton {
            Button {
                didTapButton()
            } label: {
                SystemImage(.chevronDownCircleFill, 30)
                    .symbolRenderingMode(.hierarchical)
                    .padding()
            }
            .tint(.primary)
            .transition(.move(edge: .bottom).combined(with: .scale))
        }
    }
    @MainActor private func didTapButton() {
        viewModel.scrollToBottom(true)
    }
}
