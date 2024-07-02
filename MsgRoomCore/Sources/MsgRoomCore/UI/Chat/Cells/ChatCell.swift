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
    let style: MsgCellPresenter
    
    var body: some View {
        VStack(spacing: 0) {
            if style.showTimeSeparater {
                TimeSeparaterCell(date: msg.date)
            } else if style.showTopPadding {
                Spacer(minLength: MsgRoomCore.Constants.chatCellSeparater)
            }
            HStack(alignment: .bottom, spacing: 0) {
                leftView()
                VStack(alignment: msg.recieptType.hAlignment, spacing: 2) {
                    selectedTopView()
                    ChatBubbleContent<Msg, Room, Contact>(msg: msg, style: style)
                    selectedBottomView()
                }
                rightView()
            }
        }
        .flippedUpsideDown()
        .blur(radius: style.blurredRadius)
        .equatable(by: style)
        .transition(.push(from: .top).combined(with: .move(edge: .top)).animation(.bouncy))
    }
}

extension ChatCell {
    @ViewBuilder
    private func selectedTopView() -> some View {
        if style.isSelected {
            switch msg.recieptType {
            case .Send:
                HiddenLabelView(text:  MsgDateView.dateFormatter.string(from: msg.date), padding: .top)
                    .transition(.opacity)
            case .Receive:
                HiddenLabelView(text: style.senderName ?? "", padding: .top)
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
            Spacer(minLength: MsgRoomCore.Constants.cellAlignmentSpacing)
        } else {
            VStack {
                if style.showAvatar {
                    ContactAvatarView(id: msg.senderID, urlString: style.senderURL ?? "", size: MsgRoomCore.Constants.cellLeftRightViewWidth)
                }
            }
            .frame(width: MsgRoomCore.Constants.cellLeftRightViewWidth + 7)
        }
    }
    
    @ViewBuilder
    private func rightView() -> some View {
        if msg.recieptType == .Receive {
            Spacer(minLength: MsgRoomCore.Constants.cellAlignmentSpacing)
        } else {
            VStack {
                CellProgressView(progress: msg.deliveryStatus)
                    .padding(.trailing, 7)
            }
            .frame(width: MsgRoomCore.Constants.cellLeftRightViewWidth)
        }
    }
}
