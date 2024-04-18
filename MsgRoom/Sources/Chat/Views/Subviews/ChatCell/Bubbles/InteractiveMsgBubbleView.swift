//
//  InteractiveMsgBubbleView.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 8/4/24.
//

import SwiftUI

struct InteractiveMsgBubbleView<Msg: MsgKind, Con: ConKind>: View {

    let style: MsgStyle

    @EnvironmentObject internal var chatViewModel: MsgRoomViewModel<Msg, Con>
    @Environment(Msg.self) private var msg

    @State private var computeFrame = false
    @State private var offsetX = 0.0
    @GestureState private var offset = CGSize.zero

    private let minSwipeDistance = 30.0
    private let maxSwipeDistance = 150.0
    private  let replyThreshold = 60.0

    var body: some View {
        MsgBubbleView<Msg, Con>(style: style)
            .background(frameRetriverView)
            .offset(x: offsetX)
            .onTapGesture(count: 2, perform: onDoubleTap)
            .onLongPressGesture(perform: onLongPress)
            .simultaneousGesture(dragGesture)
            .onChange(of: offset, perform: onDragged(_:))
    }
}

// Bubble Frame Retriving
extension InteractiveMsgBubbleView {
    private var frameRetriverView: some View {
        GeometryReader { proxy in
            Color.clear
                .onChange(of: computeFrame) { change in
                    if change {
                        DispatchQueue.main.async {
                            computeFrame = false
                            let frame = proxy.frame(in: .named("chatView"))
                            let info = MsgDisplayInfo(msg: msg, frame: frame, style: style)
                            chatViewModel.setMarkedMsg(info)
                        }
                    }
                }
        }
    }
}


// Gestures
extension InteractiveMsgBubbleView {

    // Double Tap Gesture
    private func onDoubleTap() {
        chatViewModel.setSelectedMsg(msg)
    }

    // Long Press Gesture
    private func onLongPress() {
        computeFrame = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            computeFrame = false
        }
    }

    // Drag Gesture
    private var dragGesture: some Gesture {
        DragGesture(minimumDistance: minSwipeDistance, coordinateSpace: .local)
            .updating($offset) { value, gestureState, trasaction in
                let diff = CGSize(width: value.location.x - value.startLocation.x, height: value.location.y - value.startLocation.y)
                if diff == .zero {
                    gestureState = .zero
                } else {
                    gestureState = value.translation
                }
            }
    }

    private func onDragged(_ newValue: CGSize) {
        if newValue == .zero {
            withAnimation(.interpolatingSpring(stiffness: 170, damping: 20)) {
                self.offsetX = 0
            }
        } else {
            dragChanged(to: newValue.width)
        }
    }

    private func dragChanged(to value: CGFloat) {
        let x = value
        if style.isSender {
            if x > 0 {
                return
            }
        } else {
            if x < 0 {
                return
            }
        }
        if abs(x) >= minSwipeDistance {
            offsetX = style.isSender ? max(x, -maxSwipeDistance) : min(x, maxSwipeDistance)
        } else {
            offsetX = 0
        }
        if abs(offsetX) > replyThreshold && chatViewModel.quotedMsg != msg {
            chatViewModel.setQuoteddMsg(msg)
        }
    }

}
