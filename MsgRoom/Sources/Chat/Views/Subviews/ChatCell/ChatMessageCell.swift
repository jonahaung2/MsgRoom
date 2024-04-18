//
//  MsgCell.swift
//  Msgr
//
//  Created by Aung Ko Min on 22/10/22.
//

import SwiftUI
import XUI
struct ChatMessageCell<Msg: MsgKind, Con: ConKind>: View {
    
    @EnvironmentObject internal var chatViewModel: MsgRoomViewModel<Msg, Con>
    @Environment(Msg.self) private var msg
    let style: MsgStyle
    
    var body: some View {
        VStack(spacing: 0) {
            if style.showTimeSeparater {
                TimeSeparaterCell(date: msg.date)
            } else if style.showTopPadding {
                Spacer(minLength: MsgKitConfigurations.chatCellSeparater)
            }
            HStack(alignment: .bottom, spacing: 0) {
                leftView()
                VStack(alignment: msg.recieptType.hAlignment, spacing: 2) {
                    if style.isSelected {
                        if let sender = msg.sender {
                            HiddenLabelView(text: sender.name, padding: .top)
                                .transition(.opacity)
                        } else {
                            HiddenLabelView(text:  MsgDateView.dateFormatter.string(from: msg.date), padding: .top)
                                .transition(.opacity)
                        }
                    }
                    bubbleView()
                        .onTapGesture{
                            if chatViewModel.focusedId != nil {
                                chatViewModel.focusedId = nil
                            } else {
                                _Haptics.play(.light)
                                withAnimation(.interactiveSpring) {
                                    chatViewModel.selectedId = msg.id == chatViewModel.selectedId ? nil : msg.id
                                }
                            }
                        }
                        .onLongPressGesture(minimumDuration: 0.05, maximumDistance: 0) {
                            _Haptics.play(.heavy)
                            withAnimation(.interactiveSpring) {
                                chatViewModel.focusedId = msg.id == chatViewModel.focusedId ? nil : msg.id
                            }
                        }
                        .modifier(DraggableModifier(direction: msg.recieptType == .Send ? .left : .right))
                    if style.isSelected {
                        HiddenLabelView(text: msg.deliveryStatus.description, padding: .bottom)
                            .transition(.opacity)
                    }
                }
                rightView()
            }
        }
        .flippedUpsideDown()
        .blur(radius: chatViewModel.focusedId == nil ? 0 : chatViewModel.focusedId == msg.id ? 0 : 5)
        .transition(.move(edge: .top))
    }
    
    @ViewBuilder
    private func leftView() -> some View {
        if msg.recieptType == .Send {
            Spacer(minLength: MsgKitConfigurations.chatCellMinMargin)
        } else {
            VStack {
                if let sender = msg.sender, style.showAvatar {
                    ContactAvatarView(id: sender.id, urlString: sender.photoUrl, size: MsgKitConfigurations.cellLeftRightViewWidth)
                }
            }
            .frame(width: MsgKitConfigurations.cellLeftRightViewWidth + 10)
        }
    }
    
    @ViewBuilder
    private func rightView() -> some View {
        if msg.recieptType == .Receive {
            Spacer(minLength: MsgKitConfigurations.cellAlignmentSpacing)
        } else {
            VStack {
                CellProgressView(progress: msg.deliveryStatus)
                    .padding(.trailing, 5)
            }
            .frame(width: MsgKitConfigurations.cellLeftRightViewWidth)
        }
    }
    @ViewBuilder
    private func bubbleView() -> some View {
        ZStack {
            switch msg.msgType {
            case .Text:
                TextBubble(text: msg.text)
                    .foregroundColor(style.textColor)
                    .background(style.bubbleShape.fill(style.bubbleColor).shadow(color: Color(uiColor: .opaqueSeparator), radius: 2))
            case .Image:
                ImageBubble()
            case .Location:
                LocationBubble<Msg, Con>()
            case .Emoji:
                Text("Emoji")
            default:
                EmptyView()
            }
        }
        .zIndex(5)
        .compositingGroup()
    }
}

struct MsgCell<Msg: MsgKind, Con: ConKind>: View {

    @EnvironmentObject internal var chatViewModel: MsgRoomViewModel<Msg, Con>
    @Environment(Msg.self) private var msg
    let style: MsgStyle

    private var sender: Contact? { msg.sender }
    var body: some View {
        VStack(spacing: 0) {
            if style.showTimeSeparater  {
                TimeSeparaterCell(date: msg.date)
            } else if style.showTopPadding {
                Spacer(minLength: 15)
            }

            HStack(alignment: .bottom, spacing: 0) {
                leftView
                VStack(alignment: style.isSender ? .trailing : .leading, spacing: 2) {
                    if style.isSelected {
                        let text = style.isSender ? MsgDateView.dateFormatter.string(from: msg.date) : sender?.name ?? ""
                        HiddenLabelView(text: text, padding: .top)
                    }
                    InteractiveMsgBubbleView<Msg, Con>(style: style)
                    if style.isSelected {
                        HiddenLabelView(text: msg.deliveryStatus.description, padding: .bottom)
                    }
                }
                rightView
            }
        }
        .flippedUpsideDown()
        .transition(.asymmetric(insertion: .move(edge: .top), removal: .opacity))
    }

    @ViewBuilder
    private var leftView: some View {
        if style.isSender {
            Spacer(minLength: MsgKitConfigurations.cellAlignmentSpacing)
        } else {
            VStack(alignment: .trailing) {
                if style.showAvatar, let sender  {
                    ContactAvatarView(id: sender.id, urlString: sender.photoUrl, size: 25)
                }
            }
            .frame(width: 25 + 5)
        }
    }
    @ViewBuilder
    private var rightView: some View {
        if !style.isSender {
            Spacer(minLength: MsgKitConfigurations.cellAlignmentSpacing)
        } else {
            VStack {
                CellProgressView(progress: msg.deliveryStatus)
            }
            .frame(width: MsgKitConfigurations.cellLeftRightViewWidth)
        }
    }
}
