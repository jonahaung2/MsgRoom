//
//  MsgCell.swift
//  Msgr
//
//  Created by Aung Ko Min on 22/10/22.
//

import SwiftUI
import XUI

struct ChatCell<Msg: MsgRepresentable, Room: RoomRepresentable, Contact: ContactRepresentable>: View {
    
    @EnvironmentObject internal var chatViewModel: MsgRoomViewModel<Msg, Room, Contact>
    
    let msg: Msg
    let style: MsgDecoration
    
    var body: some View {
        VStack(spacing: 0) {
            if style.showTimeSeparater {
                TimeSeparaterCell(date: msg.date)
            } else if style.showTopPadding {
                Spacer(minLength: MsgStyleStylingWorker.Constants.chatCellSeparater)
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
            switch msg.msgKind {
            case .Text:
                TextBubble(text: style.text)
                    .foregroundColor(style.textColor)
                    .background(style.bubbleColor, in: style.bubbleShape)
            case .Image:
                if let localPath = FileUtil.documentDirectory?.appending(path: msg.id) {
                    AsyncImage(url: localPath, scale: 0.5) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: MsgStyleStylingWorker.Constants.mediaMaxWidth)
                            .clipShape(style.bubbleShape)
                    } placeholder: {
                        ProgressView()
                    }
                } else {
                    ImageBubble(style: style)
                }
            case .Location:
                LocationBubble()
            case .Emoji:
                Text("Emoji")
            default:
                EmptyView()
            }
        }
//        .modifier(DraggableModifier(direction: msg.recieptType == .Send ? .left : .right))
        .onTapGesture{
            _Haptics.play(.light)
            chatViewModel.datasource.checkSelectedId(id: msg.id)
        }
        .onLongPressGesture(minimumDuration: 0.2, maximumDistance: 0) {
            _Haptics.play(.rigid)
            chatViewModel.datasource.checkFocusId(id: msg.id)
        }
    }
    @ViewBuilder
    private func selectedTopView() -> some View {
        if style.isSelected {
            switch msg.recieptType {
            case .Send:
                HiddenLabelView(text:  MsgDateView.dateFormatter.string(from: msg.date), padding: .top)
                    .transition(.opacity)
            case .Receive:
                HiddenLabelView(text: msg.senderID, padding: .top)
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
            Spacer(minLength: MsgStyleStylingWorker.Constants.cellAlignmentSpacing)
        } else {
            VStack {
                if style.showAvatar {
                    ContactAvatarView(id: msg.senderID, urlString: style.senderURL ?? "", size: MsgStyleStylingWorker.Constants.cellLeftRightViewWidth)
                }
            }
            .frame(width: MsgStyleStylingWorker.Constants.cellLeftRightViewWidth + 7)
        }
    }
    
    @ViewBuilder
    private func rightView() -> some View {
        if msg.recieptType == .Receive {
            Spacer(minLength: MsgStyleStylingWorker.Constants.cellAlignmentSpacing)
        } else {
            VStack {
                CellProgressView(progress: msg.deliveryStatus)
                    .padding(.trailing, 7)
            }
            .frame(width: MsgStyleStylingWorker.Constants.cellLeftRightViewWidth)
        }
    }
}
