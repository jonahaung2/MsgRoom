//
//  ScrollDownButton.swift
//  Msgr
//
//  Created by Aung Ko Min on 21/10/22.
//

import SwiftUI
import XUI
struct ScrollDownButton: View {
    
    @EnvironmentObject private var viewModel: MsgRoomViewModel<Message, Conversation>
    
    var body: some View {
        if viewModel.settings.showScrollToLatestButton {
            AsyncButton {
                didTapButton()
            } label: {
                SystemImage(.init(rawValue: "arrowshape.down.circle"), 44)
                    .fontWeight(.thin)
                    .symbolRenderingMode(.hierarchical)
                    .padding()
            }
            .transition(.move(edge: .trailing).combined(with: .scale))
            .padding(.bottom)
        }
    }
    @MainActor private func didTapButton() {
        viewModel.scrollToBottom(true)
    }
}
