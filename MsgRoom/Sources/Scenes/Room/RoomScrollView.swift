//
//  ChatScrollView.swift
//  Conversation
//
//  Created by Aung Ko Min on 31/1/22.
//

import SwiftUI
import XUI
import ImageLoader

struct RoomScrollView: View {
    
    @EnvironmentObject private var viewModel: RoomViewModel
    
    var body: some View {
        ScrollViewReader { scroller in
            ScrollView(.vertical) {
                VStack(spacing: MsgRoomCore.Constants.chatCellVerticalSpacing) {
                    Color.clear.frame(height: 0).hidden()
                        .id("0")
                    ForEach(viewModel.datasource.msgStyles, id: \.msg) { data in
                        RoomMsgCell(data: data)
                            .id(data.msg.id)
                    }
                    ZStack(alignment: .top) {
                        
                    }
                    .frame(height: 130)
                    .id("2")
                }
                .animation(.linear(duration: 0.2), value: viewModel.datasource.msgStyles.first?.style)
                .animation(.interpolatingSpring(duration: 0.2), value: viewModel.roomState.selectedId)
                .background {
                    GeometryReader { proxy in
                        let frame = proxy.scrollPosition(600).inversed
                        Color
                            .clear
                            .hidden()
                            .onChange(of: frame, debounceTime: 0.001, perform: { oldValue, newValue in
                                DispatchQueue.main.async {
                                    viewModel.didUpdateDynamicOffset(newValue)
                                }
                            })
                    }
                }
                .equatable(by: viewModel.viewChanges)
            }
            .flippedUpsideDown()
            .scrollDismissesKeyboard(.immediately)
            .scrollClipDisabled()
            .scrollContentBackground(.hidden)
            .onChange(of: viewModel.roomState.scrollItem, { _, newValue in
                if let newValue {
                    defer {
                        viewModel.roomState.scrollItem = nil
                    }
                    scroller.scroll(to: newValue)
                }
            })
        }
    }
}
