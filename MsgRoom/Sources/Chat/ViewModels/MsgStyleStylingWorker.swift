//
//  MsgStyleStylingWorker.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 7/4/24.
//

import UIKit

struct MsgStyleStylingWorker<Msg: MessageRepresentable, Con: ConversationRepresentable> {
    
    private let con: Con
    
    init(_ con: Con) {
        self.con = con
    }
    
    func msgStyle(for this: Msg, at index: Int, selectedId: String?, focusedId: String?, msgs: [Msg]) -> MsgDecoration {
        let thisIsSelectedId = this.id == selectedId
        let isSender = this.recieptType == .Send
        
        var showAvatar = false
        var showTimeSeparater = false
        var showTopPadding = false
        
        var bubbleCornors: UIRectCorner = []
        
        let previousMsg = prevMsg(for: this, at: index, from: Array(msgs))
        let nextMsg = nextMsg(for: this, at: index, from: Array(msgs))
        
        if isSender {
            
            bubbleCornors.formUnion(.topLeft)
            bubbleCornors.formUnion(.bottomLeft)
            
            if let previousMsg {
                showTimeSeparater = canShowTimeSeparater(this.date, previousMsg.date)
                if (
                    this.recieptType != previousMsg.recieptType ||
                    this.msgType != previousMsg.msgType ||
                    thisIsSelectedId ||
                    previousMsg.id == selectedId ||
                    showTimeSeparater
                ) {
                    bubbleCornors.formUnion(.topRight)
                    showTopPadding = !showTimeSeparater && this.senderId != previousMsg.senderId
                }
            } else {
                bubbleCornors.formUnion(.topRight)
            }
            
            if let nextMsg {
                if (
                    this.recieptType != nextMsg.recieptType ||
                    this.msgType != nextMsg.msgType ||
                    thisIsSelectedId ||
                    nextMsg.id == selectedId ||
                    canShowTimeSeparater(nextMsg.date, this.date)
                ) {
                    bubbleCornors.formUnion(.bottomRight)
                }
            }else {
                bubbleCornors.formUnion(.bottomRight)
            }
        } else {
            bubbleCornors.formUnion(.topRight)
            bubbleCornors.formUnion(.bottomRight)
            
            if let previousMsg = prevMsg(for: this, at: index, from: Array(msgs)) {
                showTimeSeparater = canShowTimeSeparater(this.date, previousMsg.date)
                if (
                    this.recieptType != previousMsg.recieptType ||
                    this.msgType != previousMsg.msgType ||
                    this.senderId != previousMsg.senderId ||
                    thisIsSelectedId ||
                    previousMsg.id == selectedId ||
                    showTimeSeparater
                ) {
                    bubbleCornors.formUnion(.topLeft)
                    showTopPadding = !showTimeSeparater && this.senderId != previousMsg.senderId
                }
            } else {
                bubbleCornors.formUnion(.topLeft)
            }
            
            if let nextMsg {
                if (
                    this.recieptType != nextMsg.recieptType ||
                    this.senderId != nextMsg.senderId ||
                    this.msgType != nextMsg.msgType ||
                    thisIsSelectedId ||
                    nextMsg.id == selectedId ||
                    canShowTimeSeparater(nextMsg.date, this.date)
                ) {
                    bubbleCornors.formUnion(.bottomLeft)
                    showAvatar = true
                }
            } else {
                bubbleCornors.formUnion(.bottomLeft)
                showAvatar = true
            }
        }
        
        let bubbleShape = BubbleShape(corners: bubbleCornors, cornorRadius: MsgKitConfigurations.bubbleCornorRadius)
        let textColor = this.recieptType == .Send ? MsgKitConfigurations.textTextColorOutgoing : nil
        return MsgDecoration(text: this.text, bubbleShape: bubbleShape, showAvatar: showAvatar, showTimeSeparater: showTimeSeparater, showTopPadding: showTopPadding, isSelected: thisIsSelectedId, blurredRadius: focusedId == nil ? 0 : focusedId == this.id ? 0 : 5, bubbleColor: con.bubbleColor(for: this), textColor: textColor)
    }
    
    private func prevMsg<MsgItem: MessageRepresentable>(for msg: MsgItem, at i: Int, from msgs: [MsgItem]) -> MsgItem? {
        guard i < msgs.count-1 else { return nil }
        return msgs[i + 1]
    }
    
    private func nextMsg<MsgItem: MessageRepresentable>(for msg: MsgItem, at i: Int, from msgs: [MsgItem]) -> MsgItem? {
        guard i > 0 else { return nil }
        return msgs[i - 1]
    }
    private func canShowTimeSeparater(_ date: Date, _ previousDate: Date) -> Bool {
        date.getDifference(from: previousDate, unit: .second) > MsgKitConfigurations.chatCellTimeSeparatorUnit
    }
}
