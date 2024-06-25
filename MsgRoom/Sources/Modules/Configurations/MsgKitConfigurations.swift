//
//  ChatKit.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 1/4/24.
//

import SwiftUI

enum MsgKitConfigurations {
    static let chatCellSeparater = CGFloat(10)
    static let chatCellMinMargin = CGFloat(16)
    static let chatCellVerticalSpacing = CGFloat(2)
    static let chatCellTimeSeparatorUnit = 20
    static let bubbleCornorRadius = CGFloat(16)
    static let cellAlignmentSpacing = CGFloat(38)
    static let cellMsgStatusSize = CGFloat(15)
    static let cellHorizontalPadding = CGFloat(8)
    static let textBubbleColorIncoming = Color(uiColor: .secondarySystemGroupedBackground)
    static let textBubbleColorIncomingPlain = Color(uiColor: .systemGray5)
    static let cellLeftRightViewWidth = 22.00
    static let locationBubbleSize = CGSize(width: 280, height: 200)
    static let mediaMaxWidth = CGFloat(250)
    static let textTextColorOutgoing = Color.white
    static let textTextColorIncoming: Color? = nil
}
