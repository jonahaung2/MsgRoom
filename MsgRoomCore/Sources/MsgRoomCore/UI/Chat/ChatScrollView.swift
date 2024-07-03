//
//  ChatScrollView.swift
//  Conversation
//
//  Created by Aung Ko Min on 31/1/22.
//

import SwiftUI
import XUI

struct ChatScrollView<Msg: MsgRepresentable, Room: RoomRepresentable, Contact: ContactRepresentable>: View {
    
    @EnvironmentObject private var viewModel: MsgRoomViewModel<Msg, Room, Contact>
    @Namespace private var scrolAreaId
    
    var body: some View {
        ScrollViewReader { scroller in
            ScrollView(.vertical) {
                VStack(spacing: MsgRoomCore.Constants.chatCellVerticalSpacing) {
                    Color.white.frame(height: 2)
                        .id("0")
                    ForEach(viewModel.datasource.msgStyles, id: \.msg) { msg, style in
                        ChatCell<Msg, Room, Contact>(
                            msg: msg,
                            style: style)
//                        .id(msg.id)
                    }
                }
                .animation(.linear(duration: 0.2), value: viewModel.datasource.msgStyles.first?.msg.id)
                .animation(.interpolatingSpring(duration: 0.3), value: viewModel.datasource.selectedId)
                .background {
                    GeometryReader { proxy in
                        let frame = proxy.scrollPosition().inversed
                        Color
                            .clear
                            .hidden()
                            .onChange(of: frame) { oldValue, newValue in
                                viewModel.didUpdateDynamicOffset(frame)
                            }
                    }
                }
                .equatable(by: viewModel.viewChanges)
            }
            
            .scrollDismissesKeyboard(.immediately)
            .scrollClipDisabled()
            .scrollContentBackground(.hidden)
            .coordinateSpace(name: scrolAreaId)
            .flippedUpsideDown()
            .onChange(of: viewModel.settings.scrollItem, { oldValue, newValue in
                if oldValue == nil, let newValue, oldValue != newValue {
                    defer {
                        viewModel.settings.scrollItem = nil
                    }
                    scroller.scroll(to: newValue)
                }
            })
        }
    }
}
