//
//  ScrollDownButton.swift
//  Msgr
//
//  Created by Aung Ko Min on 21/10/22.
//

import SwiftUI

struct ScrollDownButton: View {
    
    @EnvironmentObject private var viewModel: MsgRoomViewModel<Message>
    
    var body: some View {
        HStack(alignment: .bottom) {
            Spacer()
            if viewModel.showScrollToLatestButton {
                Button(action: didTapButton) {
                    Image(systemName: "chevron.down.circle.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .padding()
                }
                .transition(.scale(scale: 0.1))
            }
        }
    }
    private func didTapButton() {
        viewModel.scrollToBottom(true)
    }
}