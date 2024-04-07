//
//  ChatScrollView.swift
//  Conversation
//
//  Created by Aung Ko Min on 31/1/22.
//

import SwiftUI
import XUI

struct ChatScrollView<MsgItem: MessageRepresentable, ConItem: ConversationRepresentable>: View {
    
    @EnvironmentObject private var viewModel: MsgRoomViewModel<MsgItem, ConItem>
    private let scrollAreaId = "scrollArea"
    
    var body: some View {
        ScrollViewReader { scroller in
            ScrollView(.vertical) {
                LazyVStack(spacing: MsgKitConfigurations.chatCellVerticalSpacing) {
                    ForEach(viewModel.datasource.enuMsgs, id: \.element) { i, msg in
                        ChatCell<MsgItem, ConItem>(
                            style: viewModel.msgStyleWorker.msgStyle(
                                for: msg,
                                at: i,
                                selectedId: viewModel.selectedId,
                                msgs: viewModel.datasource.allMsgs, thisIsSelectedId: viewModel.selectedId)
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
            .onChange(of: viewModel.scrollItem, { oldValue, newValue in
                if let newValue {
                    defer {
                        self.viewModel.scrollItem = nil
                    }
                    scroller.scroll(to: newValue)
                }
            })
        }
    }
}
