//
//  MsgStyleStylingWorker.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 7/4/24.
//

import UIKit
import XUI
import SwiftUI

struct MsgStyleStylingWorker<Msg: MsgKind, Con: ConKind> {
    
    private let con: Con
    init(_ con: Con) {
        self.con = con
    }
    
    private func canShowTimeSeparater(_ date: Date, _ previousDate: Date) -> Bool {
        abs(date.getDifference(from: previousDate, unit: .second)) > 60
    }

    func msgStyle(prev: Msg?, msg: Msg, next: Msg?, selectedMsg: Msg?) -> MsgStyle {
        var cornors: UIRectCorner = []
        var showAvatar = false
        var showTimeSeparater = false
        var showTopPadding = false

        let isSelected = msg.id == selectedMsg?.id
        let nextIsSelected = next?.id == selectedMsg?.id
        let prevIsSelected = prev?.id == selectedMsg?.id

        let isSender = msg.sender?.id == Contact.currentUser.id

        if isSender {
            cornors.formUnion(.topLeft)
            cornors.formUnion(.bottomLeft)
            if let prev {
                showTimeSeparater = self.canShowTimeSeparater(msg.date, prev.date)
                showTopPadding = !showTimeSeparater && msg.sender?.id != prev.sender?.id
                if (showTimeSeparater || showTopPadding || msg.msgType != prev.msgType || isSelected || prevIsSelected ) {
                    cornors.formUnion(.topRight)
                }
            } else {
                cornors.formUnion(.topRight)

            }
            if let next {
                if
                    msg.sender?.id != next.sender?.id ||
                     msg.msgType != next.msgType ||
                     isSelected ||
                     nextIsSelected ||
                     canShowTimeSeparater(msg.date, next.date) {

                    cornors.formUnion(.bottomRight)
                }
            }else {
                cornors.formUnion(.bottomRight)
            }
        } else {
            cornors.formUnion(.topRight)
            cornors.formUnion(.bottomRight)
            if let prev {
                showTimeSeparater = canShowTimeSeparater(msg.date, prev.date)
                showTopPadding = !showTimeSeparater && msg.sender?.id != prev.sender?.id

                if showTopPadding || showTimeSeparater || msg.msgType != prev.msgType || isSelected || prevIsSelected {
                    cornors.formUnion(.topLeft)
                }
            } else {
                cornors.formUnion(.topLeft)
            }

            if let next {
                if msg.sender?.id != next.sender?.id || msg.msgType != next.msgType || isSelected || nextIsSelected || canShowTimeSeparater(msg.date, next.date) {

                    cornors.formUnion(.bottomLeft)
                }
            } else {
                cornors.formUnion(.bottomLeft)
            }
            showAvatar = cornors.contains(.bottomLeft)
        }

        let bubbleShape = BubbleShape(corners: cornors, cornorRadius: 16)
        let textColor = isSender ? Color.white : nil
        let bubbleColor = con.bubbleColor(for: msg)

        let reducted = false

        return MsgStyle(bubbleShape: bubbleShape, showAvatar: showAvatar, showTimeSeparater: showTimeSeparater, showTopPadding: showTopPadding, isSelected: isSelected, bubbleColor: bubbleColor, textColor: textColor, isSender: isSender, reducted: reducted)
    }
}
