//
//  MsgCell.swift
//  Msgr
//
//  Created by Aung Ko Min on 22/10/22.
//

import SwiftUI
import XUI


struct ChatCell<Msg: MessageRepresentable, Con: ConversationRepresentable>: View {
    
    @EnvironmentObject internal var chatViewModel: MsgRoomViewModel<Msg, Con>
    let msg: Msg
    let style: MsgDecoration
    
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
                    selectedTopView()
                    bubbleView()
                    selectedBottomView()
                }
                rightView()
            }
        }
        .flippedUpsideDown()
        .blur(radius: style.blurredRadius)
        .equatable(by: style)
        .transition(.push(from: .top))
    }
}

extension ChatCell {
    @ViewBuilder
    private func bubbleView() -> some View {
        ZStack {
            switch msg.msgType {
            case .Text:
                TextBubble(text: style.text)
                    .foregroundColor(style.textColor)
                    .background(style.bubbleColor, in: style.bubbleShape)
            case .Image:
                ImageBubble(style: style)
            case .Location:
                LocationBubble()
            case .Emoji:
                Text("Emoji")
            default:
                EmptyView()
            }
        }
        .onTapGesture{
            if chatViewModel.settings.focusedId != nil {
                chatViewModel.settings.focusedId = nil
            } else {
                _Haptics.play(.light)
                chatViewModel.settings.selectedId = msg.id == chatViewModel.settings.selectedId ? nil : msg.id
            }
        }
        .onLongPressGesture(minimumDuration: 0.05, maximumDistance: 0) {
            _Haptics.play(.heavy)
            chatViewModel.settings.focusedId = msg.id == chatViewModel.settings.focusedId ? nil : msg.id
        }
        .modifier(DraggableModifier(direction: msg.recieptType == .Send ? .left : .right))
        .compositingGroup()
    }
    @ViewBuilder
    private func selectedTopView() -> some View {
        if style.isSelected {
            switch msg.recieptType {
            case .Send:
                HiddenLabelView(text:  MsgDateView.dateFormatter.string(from: msg.date), padding: .top)
                    .transition(.opacity)
            case .Receive:
                HiddenLabelView(text: msg.senderId, padding: .top)
                    .transition(.opacity)
            }
        }
    }
    @ViewBuilder
    private func selectedBottomView() -> some View {
        if style.isSelected {
            HiddenLabelView(text: msg.deliveryStatus.description, padding: .bottom)
                .transition(.opacity)
        }
    }
    
    @ViewBuilder
    private func leftView() -> some View {
        if msg.recieptType == .Send {
            Spacer(minLength: MsgKitConfigurations.chatCellMinMargin)
        } else {
            VStack {
                if style.showAvatar {
                    ContactAvatarView(id: msg.senderId, urlString: MockDataStore.demoPhotosURLs.random()!.absoluteString, size: MsgKitConfigurations.cellLeftRightViewWidth)
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
}