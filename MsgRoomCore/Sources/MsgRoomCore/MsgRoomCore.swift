//
//  File.swift
//
//
//  Created by Aung Ko Min on 2/7/24.
//

import SwiftUI

public struct MsgRoomCore {
    
    var incomingSocket = IncomingSocket()
    var outgoingSocket = OutgoingSocket()
    
    enum Constants {
        static let textBubbleColorOutgoing = Color.Shadow.green
        static let textBubbleColorIncomingPlain = Color.Shadow.yellow
        static let chatCellSeparater = CGFloat(10)
        static let chatCellVerticalSpacing = CGFloat(5)
        static let chatCellTimeSeparatorUnitInSeconds = 10
        static let bubbleCornorRadius = CGFloat(15)
        static let cellAlignmentSpacing = CGFloat(40)
        static let cellMsgStatusSize = CGFloat(15)
        static let cellHorizontalPadding = CGFloat(8)
        
        static let cellLeftRightViewWidth = CGFloat(20)
        static let locationBubbleSize = CGSize(width: 280, height: 200)
        static let mediaMaxWidth = CGFloat(250)
        static let textTextColorOutgoing = Color.white
        static let textTextColorIncoming: Color? = nil
    }
    
    public init() {}
}
