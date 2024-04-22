//
//  MsgStyle.swift
//  Conversation
//
//  Created by Aung Ko Min on 3/3/22.
//

import SwiftUI

public struct MessageStyle: Hashable, Identifiable, Sendable {
    public var id: MessageStyle { self }
    let bubbleShape: BubbleShape
    let showAvatar: Bool
    let showTimeSeparater: Bool
    let showTopPadding: Bool
    let isSelected: Bool
    let blurredRadius: CGFloat
    let bubbleColor: Color
    let textColor: Color?
}
