//
//  MsgStyle.swift
//  Conversation
//
//  Created by Aung Ko Min on 3/3/22.
//

import SwiftUI
import XUI

public struct MsgCellLayout: Conformable {
    public var id: MsgCellLayout { self }
    public var content: Content
    public var isSender: Bool
    public var bubbleShape: BubbleShape
    public var showAvatar: Bool
    public var showTimeSeparater: Bool
    public var showTopPadding: Bool
    public var isSelected: Bool
    public var blurredRadius: CGFloat
    public var bubbleColor: Color
    public var textColor: Color?
    public var senderURL: String?
    public var senderName: String?
    
    public init(
        content: Content,
        isSender: Bool,
        bubbleShape: BubbleShape,
        showAvatar: Bool,
        showTimeSeparater: Bool,
        showTopPadding: Bool,
        isSelected: Bool,
        blurredRadius: CGFloat,
        bubbleColor: Color,
        textColor: Color? = nil,
        senderURL: String? = nil,
        senderName: String? = nil
    ) {
        self.content = content
        self.isSender = isSender
        self.bubbleShape = bubbleShape
        self.showAvatar = showAvatar
        self.showTimeSeparater = showTimeSeparater
        self.showTopPadding = showTopPadding
        self.isSelected = isSelected
        self.blurredRadius = blurredRadius
        self.bubbleColor = bubbleColor
        self.textColor = textColor
        self.senderURL = senderURL
        self.senderName = senderName
    }
}

extension MsgCellLayout {
    public enum Content: Conformable  {
        public var id: Content { self }
        case text(_ text: String)
        case image(_ url: URL)
        case fileImage(_ image: UIImage, ratio: CGFloat)
        case emoji(_ image: UIImage)
        case link(_ url: URL)
    }
}
