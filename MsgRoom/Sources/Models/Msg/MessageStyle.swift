//
//  MsgStyle.swift
//  Conversation
//
//  Created by Aung Ko Min on 3/3/22.
//

import SwiftUI

struct MessageStyle: Hashable, Identifiable, Sendable {
    var id: MessageStyle { self }
    let bubbleShape: BubbleShape
    let showAvatar: Bool
    let showTimeSeparater: Bool
    let showTopPadding: Bool
    let isSelected: Bool
    let blurredRadius: CGFloat
    let bubbleColor: Color
    let textColor: Color?
}
