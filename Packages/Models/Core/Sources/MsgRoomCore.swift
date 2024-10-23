//
//  File.swift
//
//
//  Created by Aung Ko Min on 2/7/24.
//

import SwiftUI

public struct MsgRoomCore {
    public enum Constants {
        public static let chatCellSeparater = CGFloat(10)
        public static let chatCellVerticalSpacing = CGFloat(4)
        public static let chatCellTimeSeparatorUnitInSeconds = 10
        public static let bubbleCornorRadius = CGFloat(18)
        public static let cellAlignmentSpacing = CGFloat(40)
        public static let cellMsgStatusSize = CGFloat(15)
        public static let cellHorizontalPadding = CGFloat(8)
        
        public static let cellLeftRightViewWidth = CGFloat(20)
        public static let locationBubbleSize = CGSize(width: 280, height: 200)
        public static let mediaMaxWidth = CGFloat(280)
        public static let textTextColorOutgoing = Color.white
        public static let textTextColorIncoming: Color? = nil
    }
    
    public init() {}
}
