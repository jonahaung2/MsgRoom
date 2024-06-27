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
    private let queue = DispatchQueue(label: "chat")
    var body: some View {
        ScrollViewReader { scroller in
            ScrollView(.vertical) {
                LazyVStack(spacing: MsgKitConfigurations.chatCellVerticalSpacing) {
                    ForEach(viewModel.datasource.msgStyles, id: \.msg) { msg, style in
                        ChatCell<Msg, Con>(
                            msg: msg,
                            style: style)
                        .id(msg.id)
                        .scrollTransition { effect, phase in
                            effect.offset(y: -12*phase.value)
                        }
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
            .scrollDismissesKeyboard(.immediately)
            .coordinateSpace(name: scrollAreaId)
            .flippedUpsideDown()
            .onPreferenceChange(FramePreferenceKey.self) { frame in
                queue.sync {
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
