//
//  ChatScrollView.swift
//  Conversation
//
//  Created by Aung Ko Min on 31/1/22.
//

import SwiftUI
import XUI

struct ChatScrollView<Msg: MessageRepresentable, Con: ConversationRepresentable>: View {
    @EnvironmentObject private var viewModel: MsgRoomViewModel<Msg, Con>
    private let scrollAreaId = "scrollArea"
    private let locak = RecursiveLock()
    var body: some View {
        ScrollViewReader { scroller in
            ScrollView(.vertical) {
                LazyVStack(spacing: MsgKitConfigurations.chatCellVerticalSpacing) {
                    ForEach(viewModel.datasource.enuMsgs, id: \.element) { i, msg in
                        ChatCell<Msg, Con>(
                            msg: msg,
                            style: viewModel.msgStyleWorker.msgStyle(
                                for: msg,
                                at: i,
                                selectedId: viewModel.settings.selectedId,
                                focusedId: viewModel.settings.focusedId,
                                msgs: viewModel.datasource.allMsgs
                            )
                        )
                        .id(msg.id)
                    }
                }
                .scrollTargetLayout()
                .equatable(by: viewModel.change)
                .background(
                    GeometryReader { proxy in
                        let frame = proxy.frame(in: .named(scrollAreaId))
                        Color.clear
                            .hidden()
                            .preference(key: FramePreferenceKey.self, value: Bool.random() ? frame : nil)
                    }
                )
            }
            .scrollContentBackground(.visible)
            .scrollClipDisabled(true)
            .scrollDismissesKeyboard(.immediately)
            .coordinateSpace(name: scrollAreaId)
            .flippedUpsideDown()
            .onPreferenceChange(FramePreferenceKey.self) { frame in
                locak.sync {
                    if let frame {
                        viewModel.didUpdateVisibleRect(frame)
                    }
                }
            }
            .onChange(of: viewModel.settings.scrollItem, { oldValue, newValue in
                locak.sync {
                    if oldValue == nil, let newValue {
                        viewModel.settings.scrollItem = nil
                        scroller.scroll(to: newValue)
                    }
                }
            })
        }
    }
}
