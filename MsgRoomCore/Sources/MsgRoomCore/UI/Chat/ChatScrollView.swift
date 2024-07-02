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
                        .onTapGesture {
                            scroller.scrollTo("")
                        }
                    ForEach(viewModel.datasource.msgStyles, id: \.msg) { msg, style in
                        ChatCell<Msg, Room, Contact>(
                            msg: msg,
                            style: style)
                        .id(msg.id)
                    }
                }
                .animation(.linear(duration: 0.2), value: viewModel.datasource.msgStyles.first?.msg.id)
                .animation(.interpolatingSpring(duration: 0.3), value: viewModel.datasource.selectedId)
                .background {
                    GeometryReader { proxy in
                        let frame = proxy.frame(in: .named(scrolAreaId))
                        Color.clear
                            .hidden()
                            .preference(key: FramePreferenceKey.self, value: Bool.random() ? frame : nil)
                    }
                }
                .equatable(by: viewModel.viewChanges)
            }
            .scrollDismissesKeyboard(.immediately)
            .scrollClipDisabled()
            .scrollContentBackground(.hidden)
            .coordinateSpace(name: scrolAreaId)
            .flippedUpsideDown()
            .onPreferenceChange(FramePreferenceKey.self) { frame in
                DispatchQueue.main.async {
                    if let frame {
                        viewModel.didUpdateVisibleRect(frame)
                    }
                }
            }
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
