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
    private let scrollAreaId = "scrollArea"
    
    var body: some View {
        ScrollViewReader { scroller in
            ScrollView(.vertical) {
                VStack(spacing: MsgStyleStylingWorker.Constants.chatCellVerticalSpacing) {
                    Color.clear.frame(height: 0.1)
                        .hidden()
                        .id("0")
                    ForEach(viewModel.datasource.msgStyles, id: \.msg) { msg, style in
                        ChatCell<Msg, Room, Contact>(
                            msg: msg,
                            style: style)
                        .id(msg.id)
                    }
                }
                .scrollTargetLayout()
                .animation(.interpolatingSpring, value: viewModel.datasource.msgStyles.first?.msg.id)
                .animation(.easeInOut, value: viewModel.datasource.selectedId)
                .background {
                    GeometryReader { proxy in
                        let frame = proxy.frame(in: .named(scrollAreaId))
                        Color.clear
                            .hidden()
                            .preference(key: FramePreferenceKey.self, value: Bool.random() ? frame : nil)
                    }
                }
                .equatable(by: viewModel.viewChanges)
            }
            
            .scrollClipDisabled()
            .scrollContentBackground(.visible)
            .scrollDismissesKeyboard(.immediately)
            .coordinateSpace(name: scrollAreaId)
            .flippedUpsideDown()
            .background(Color(uiColor: .tertiarySystemGroupedBackground).opacity(1))
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
