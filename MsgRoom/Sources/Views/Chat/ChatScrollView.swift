//
//  ChatScrollView.swift
//  Conversation
//
//  Created by Aung Ko Min on 31/1/22.
//

import SwiftUI
import XUI
import ImageLoader

struct ChatScrollView<Msg: MsgRepresentable, Room: RoomRepresentable, Contact: ContactRepresentable>: View {
    
    @EnvironmentObject private var viewModel: MsgRoomViewModel<Msg, Room, Contact>
    @StateObject private var preFetcher = ChatMsgPreFetcher()
    
    var body: some View {
        ScrollViewReader { scroller in
            ScrollView(.vertical) {
                VStack(spacing: MsgRoomCore.Constants.chatCellVerticalSpacing) {
                    Color.Shadow.main.frame(height: 1).hidden()
                        .id("0")
                    ForEach(viewModel.datasource.msgStyles, id: \.msg) { msg, style in
                        ChatCell<Msg, Room, Contact>(
                            msg: msg,
                            style: style
                        )
                        .id(msg.id)
                    }
                    ZStack(alignment: .top) {
                        
                    }
                    .frame(height: 130)
                    .id("2")
                }
                .animation(.linear(duration: 0.2), value: viewModel.datasource.msgStyles.first?.msg.id)
                .animation(.interpolatingSpring(duration: 0.3), value: viewModel.datasource.selectedId)
                .background {
                    GeometryReader { proxy in
                        let frame = proxy.scrollPosition(400).inversed
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
            .flippedUpsideDown()
            .scrollDismissesKeyboard(.immediately)
            .scrollClipDisabled()
            .scrollContentBackground(.hidden)
            .onChange(of: viewModel.settings.scrollItem, { _, newValue in
                defer {
                    viewModel.settings.scrollItem = nil
                }
                if let newValue {
                    scroller.scroll(to: newValue)
                }
            })
        }
    }
}
