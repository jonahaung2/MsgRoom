//
//  ScrollDownButton.swift
//  Msgr
//
//  Created by Aung Ko Min on 21/10/22.
//

import SwiftUI
import XUI

public struct RoomScrollDownButton: View {
    
    @EnvironmentObject private var viewModel: RoomViewModel
    
    public var body: some View {
        if viewModel.roomState.showScrollToLatestButton {
            AsyncButton {
                didTapButton()
            } label: {
                ZStack {
                    Circle().fill(Color(uiColor: .systemBackground))
                    SystemImage(.chevronDown)
                }
                .frame(square: 35)
            }
            .transition(.move(edge: .bottom).combined(with: .scale).animation(.interpolatingSpring))
            
        }
    }
    @MainActor private func didTapButton() {
        viewModel.roomState.scrollItem = nil
        viewModel.scrollToBottom(true)
    }
}
