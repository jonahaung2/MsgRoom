//
//  ChatScrollView.swift
//  Conversation
//
//  Created by Aung Ko Min on 31/1/22.
//

import SwiftUI
import XUI

struct ChatScrollView<Msg: MsgKind, Con: ConKind>: View {
    
    @EnvironmentObject private var viewModel: MsgRoomViewModel<Msg, Con>
    private let scrollAreaId = "scrollArea"
     
    var body: some View {
        ScrollViewReader { scroller in
            ScrollView(.vertical) {
                VStack(spacing: 0) {
                    Spacer(minLength: 2).id(1)
                    LazyVStack(spacing: MsgKitConfigurations.chatCellVerticalSpacing) {
                        ForEach(viewModel.datasource.blocks, id: \.msg) {  prev, msg, next in
                            let style = viewModel.msgStyleWorker.msgStyle(prev: prev, msg: msg, next: next, selectedMsg: viewModel.selectedMsg)
                            MsgCell<Msg, Con>(style: style)
                                .environment(msg)
                        }
                    }
                    .animation(.easeOut(duration: 0.2), value: viewModel.datasource.allMsgsCount)
                    .animation(.interactiveSpring(), value: viewModel.selectedMsg)
                }
                    .background(
                        GeometryReader {
                            Color.clear
                                .preference(key: FramePreferenceKey.self, value: $0.frame(in: .named(scrollAreaId)))
                        }
                    )
            }
            .coordinateSpace(name: scrollAreaId)
            .flippedUpsideDown()
            .scrollDismissesKeyboard(.immediately)
            .onPreferenceChange(FramePreferenceKey.self) { frame in
                if let frame {
                    DispatchQueue.main.async {
                        viewModel.didUpdateVisibleRect(frame)
                    }
                }
            }
            .onChange(of: viewModel.scrollItem) {
                scroller.scroll(to: $0)
            }
        }
    }
}
