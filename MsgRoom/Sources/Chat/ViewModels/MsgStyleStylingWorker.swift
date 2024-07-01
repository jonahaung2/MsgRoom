//
//  MsgStyleStylingWorker.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 7/4/24.
//

import SwiftUI
import XUI

final class MsgStyleStylingWorker {
    
    private var cache = [String: MsgDecoration]()
    private var cachedSelectedId: String? {
        didSet {
            guard oldValue != cachedSelectedId else { return }
            resetCache()
        }
    }
    private var cachedFoucsId: String? {
        didSet {
            guard oldValue != cachedFoucsId else { return }
            resetCache()
        }
    }
    
    enum Constants {
        static let textBubbleColorOutgoing = Color.accentColor
        static let textBubbleColorIncomingPlain = Color(uiColor: .systemBackground)
        static let chatCellSeparater = CGFloat(10)
        static let chatCellVerticalSpacing = CGFloat(2)
        static let chatCellTimeSeparatorUnitInSeconds = 10
        static let bubbleCornorRadius = CGFloat(16)
        static let cellAlignmentSpacing = CGFloat(40)
        static let cellMsgStatusSize = CGFloat(15)
        static let cellHorizontalPadding = CGFloat(8)
        
        static let cellLeftRightViewWidth = CGFloat(18)
        static let locationBubbleSize = CGSize(width: 280, height: 200)
        static let mediaMaxWidth = CGFloat(250)
        static let textTextColorOutgoing = Color.white
        static let textTextColorIncoming: Color? = nil
    }
    
    func msgStyle<Msg: MsgRepresentable>(
        for msg: Msg,
        at index: Int,
        selectedId: String?,
        focusedId: String?,
        msgs: [Msg]
    ) -> MsgDecoration {
        
        cachedSelectedId = selectedId
        cachedFoucsId = focusedId
        
        let canRetriveFromCache: Bool = {
            let canRetrive = index != 1
            return canRetrive
        }()
        
        let id = msg.id
        if canRetriveFromCache, let cached = cache[id] {
            return cached
        }
        let msgIsSelected = id == selectedId
        let isSender = msg.recieptType == .Send
        
        var showAvatar = false
        var showTimeSeparater = false
        var showTopPadding = false
        
        let previousMsg = prevMsg(at: index, from: msgs)
        let nextMsg = nextMsg(at: index, from: msgs)
        
        var bubbleCornors = UIRectCorner()
        
        if isSender {
            bubbleCornors.formUnion(.topLeft)
            bubbleCornors.formUnion(.bottomLeft)
            
            if let previousMsg {
                showTimeSeparater = canShowTimeSeparater(msg.date, previousMsg.date)
                if (
                    msg.recieptType != previousMsg.recieptType ||
                    msg.msgKind != previousMsg.msgKind ||
                    msgIsSelected ||
                    previousMsg.id == selectedId ||
                    showTimeSeparater
                ) {
                    bubbleCornors.formUnion(.topRight)
                    showTopPadding = !showTimeSeparater && msg.senderID != previousMsg.senderID
                }
            } else {
                bubbleCornors.formUnion(.topRight)
            }
            
            if let nextMsg {
                if (
                    msg.recieptType != nextMsg.recieptType ||
                    msg.msgKind != nextMsg.msgKind ||
                    msgIsSelected ||
                    nextMsg.id == selectedId ||
                    canShowTimeSeparater(nextMsg.date, msg.date)
                ) {
                    bubbleCornors.formUnion(.bottomRight)
                }
            }else {
                bubbleCornors.formUnion(.bottomRight)
            }
        } else {
            bubbleCornors.formUnion(.topRight)
            bubbleCornors.formUnion(.bottomRight)
            
            if let previousMsg {
                showTimeSeparater = canShowTimeSeparater(msg.date, previousMsg.date)
                if (
                    msg.recieptType != previousMsg.recieptType ||
                    msg.msgKind != previousMsg.msgKind ||
                    msg.senderID != previousMsg.senderID ||
                    msgIsSelected ||
                    previousMsg.id == selectedId ||
                    showTimeSeparater
                ) {
                    bubbleCornors.formUnion(.topLeft)
                    showTopPadding = !showTimeSeparater && msg.senderID != previousMsg.senderID
                }
            } else {
                bubbleCornors.formUnion(.topLeft)
            }
            
            if let nextMsg {
                if (
                    msg.recieptType != nextMsg.recieptType ||
                    msg.senderID != nextMsg.senderID ||
                    msg.msgKind != nextMsg.msgKind ||
                    msgIsSelected ||
                    nextMsg.id == selectedId ||
                    canShowTimeSeparater(nextMsg.date, msg.date)
                ) {
                    bubbleCornors.formUnion(.bottomLeft)
                    showAvatar = true
                }
            } else {
                bubbleCornors.formUnion(.bottomLeft)
                showAvatar = true
            }
        }
        
        let text = msg.text
        let bubbleShape = BubbleShape(corners: bubbleCornors, cornorRadius: Constants.bubbleCornorRadius)
        let textColor = msg.recieptType == .Send ? Constants.textTextColorOutgoing : nil
        let sender: Contact? = msg.sender()
        let bubbleColor = bubbleColor(for: msg)
        let blurredRadius: CGFloat = focusedId == nil ? 0 : focusedId == msg.id ? 0 : 5
        let senderURL = sender?.photoURL
        
        let result = MsgDecoration(
            text: text,
            bubbleShape: bubbleShape,
            showAvatar: showAvatar,
            showTimeSeparater: showTimeSeparater,
            showTopPadding: showTopPadding,
            isSelected: msgIsSelected,
            blurredRadius: blurredRadius,
            bubbleColor: bubbleColor,
            textColor: textColor,
            senderURL: senderURL
        )
        cache[id] = result
        return result
    }
    
    private func prevMsg<MsgItem: MsgRepresentable>(at i: Int, from msgs: [MsgItem]) -> MsgItem? {
        guard i < msgs.count-1 else { return nil }
        return msgs[i + 1]
    }
    
    private func nextMsg<MsgItem: MsgRepresentable>(at i: Int, from msgs: [MsgItem]) -> MsgItem? {
        guard i > 0 else { return nil }
        return msgs[i - 1]
    }
    private func canShowTimeSeparater(_ date: Date, _ previousDate: Date) -> Bool {
        date.getDifference(from: previousDate, unit: .second) > Constants.chatCellTimeSeparatorUnitInSeconds
    }
    private func bubbleColor(for msg: any MsgRepresentable) -> Color {
        msg.recieptType == .Send ?
        Constants.textBubbleColorOutgoing
        :
        Constants.textBubbleColorIncomingPlain
    }
    func resetCache() {
        cache.removeAll()
        Log("reset cache")
    }
}
