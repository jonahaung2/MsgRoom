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
        if viewModel.showScrollToLatestButton {
            Button {
                didTapButton()
            } label: {
                ZStack {
                    Circle().fill(Color.Shadow.blue)
                    SystemImage(.chevronDown, 20)
                }
                .frame(square: 44)
            }
            .transition(.move(edge: .bottom).combined(with: .scale))
        }
    }
    @MainActor private func didTapButton() {
        viewModel.scrollToBottom(true)
    }
}
