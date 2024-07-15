//
//  ChatBubbleContent.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 1/7/24.
//

import SwiftUI
import XUI

struct ChatBubbleContent: View {
    
    let msg: Msg
    let style: MsgCellLayout
    @EnvironmentObject private var chatViewModel: RoomViewModel
    
    enum Direction {
        case left, right, top, bottom
        var isVertical: Bool { self == .top || self == .bottom }
        var isHorizontal: Bool { self == .left || self == .right }
        
        func offset(for draggableOffset: CGSize) -> CGSize {
            let width = self.isVertical ? 0 : (self == .left ? min(0, min(draggableOffset.width, 150)) : max(0, min(draggableOffset.width, 150)))
            let height = self.isHorizontal ? 0 : (self == .top ? max(0, draggableOffset.height) : min(0, draggableOffset.height))
            return .init(width: width, height: height)
        }
    }
    
    private var direction: Direction {
        style.isSender ? .left : .right
    }
    @State private var draggedOffset: CGSize = .zero
    
    var body: some View {
        Group {
            switch style.content {
            case .text(let text):
                TextBubble(text: text)
            case .fileImage(let image, let ratio):
                ImageBubble(urlString: msg.text, image: image, ratio: ratio, shape: style.bubbleShape)
                    .clipShape(style.bubbleShape)
            case .image(let url):
                ImageBubble(urlString: url.absoluteString, image: nil, shape: style.bubbleShape)
                    .clipShape(style.bubbleShape)
            case .emoji(let image):
                Image(uiImage: image)
            case .link(let url):
                let fetcher = LinkDataFetcher(link: url.absoluteString)
                LinkPreviewView(linkDataFetcher: fetcher)
                    .clipShape(style.bubbleShape)
                    .font(.subheadline)
            }
        }
        .background {
            style
                .bubbleColor
                .clipShape(style.bubbleShape)
                .softOuterShadow(offset: 2, radius: 0, isLeftToRight: style.isSender)
        }
        .equatable(by: style)
        .offset(draggedOffset)
        .gesture(
            TapGesture().onEnded {
                _Haptics.play(.light)
                draggedOffset = .zero
                chatViewModel.setSelectedMsg(msg.id)
            }.exclusively(
                before:
                    LongPressGesture(minimumDuration: 2, maximumDistance: 0).onChanged { _ in
                        _Haptics.play(.rigid)
                        draggedOffset = .zero
                        chatViewModel.setFocusedMsg(msg.id)
                    }.exclusively(
                        before: DragGesture(minimumDistance: 30)
                            .onChanged { value in
                                let offset = direction.offset(for: value.translation)
                                self.draggedOffset = offset
                            }
                            .onEnded { value in
                                if draggedOffset.width != 0 {
                                    _Haptics.play(.rigid)
                                }
                                draggedOffset.width = 0
                            }
                    )
            )
            
        )
    }
}
