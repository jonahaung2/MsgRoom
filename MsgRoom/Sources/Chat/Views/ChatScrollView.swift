//
//  ChatScrollView.swift
//  Conversation
//
//  Created by Aung Ko Min on 31/1/22.
//

import SwiftUI
import XUI
import MsgrCore

struct ChatScrollView<MsgItem: MessageRepresentable>: View {
    
    @EnvironmentObject private var viewModel: MsgRoomViewModel<MsgItem>
    private let scrollAreaId = "scrollArea"
    
    var body: some View {
        ScrollViewReader { scroller in
            ScrollView(.vertical) {
                LazyVStack(spacing: MsgKitConfigurations.chatCellVerticalSpacing) {
                    ForEach(viewModel.datasource.enuMsgs, id: \.element) { i, msg in
                        ChatCell<MsgItem>(
                            style: viewModel.msgStyleWorker.msgStyle(
                                for: msg,
                                at: i,
                                selectedId: viewModel.settings.selectedId,
                                focusedId: viewModel.settings.focusedId,
                                msgs: viewModel.datasource.allMsgs
                            )
                        )
                        .environment(msg)
                    }
                }
                .id(1)
                .background(
                    GeometryReader { proxy in
                        let frame = proxy.frame(in: .named(scrollAreaId))
                        Color.clear
                            .preference(key: FramePreferenceKey.self, value: frame)
                    }
                )
            }
            .scrollDismissesKeyboard(.immediately)
            .coordinateSpace(name: scrollAreaId)
            .flippedUpsideDown()
            .onPreferenceChange(FramePreferenceKey.self) { frame in
                if let frame {
                    DispatchQueue.main.async {
                        viewModel.didUpdateVisibleRect(frame)
                    }
                }
            }
            .onChange(of: viewModel.settings.scrollItem, { oldValue, newValue in
                if let newValue {
                    defer {
                        self.viewModel.settings.scrollItem = nil
                    }
                    scroller.scroll(to: newValue)
                }
            })
        }
    }
}
