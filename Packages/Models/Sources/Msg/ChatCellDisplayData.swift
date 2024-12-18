//
//  MsgStyle.swift
//  Conversation
//
//  Created by Aung Ko Min on 3/3/22.
//

import SwiftUI
public struct ChatCellDisplayData: Conformable {
    public var id: ChatCellDisplayData { self }
    public var content: Content
    public var isSender: Bool
    public var bubbleShape: BubbleShape
    public var showAvatar: Bool
    public var showTimeSeparater: Bool
    public var showTopPadding: Bool
    public var isSelected: Bool
    public var bubbleColor: Color
    public var textColor: Color?
    public var senderURL: String?
    public var senderName: String?
    public var horizontalAlignment: HorizontalAlignment
    public let deliveryStatus: MsgDeliveryStatus
    
    public init(
        content: Content,
        isSender: Bool,
        bubbleShape: BubbleShape,
        showAvatar: Bool,
        showTimeSeparater: Bool,
        showTopPadding: Bool,
        isSelected: Bool,
        bubbleColor: Color,
        textColor: Color? = nil,
        senderURL: String? = nil,
        senderName: String? = nil,
        horizontalAlignment: HorizontalAlignment,
        deliveryStatus: MsgDeliveryStatus
    ) {
        self.content = content
        self.isSender = isSender
        self.bubbleShape = bubbleShape
        self.showAvatar = showAvatar
        self.showTimeSeparater = showTimeSeparater
        self.showTopPadding = showTopPadding
        self.isSelected = isSelected
        self.bubbleColor = bubbleColor
        self.textColor = textColor
        self.senderURL = senderURL
        self.senderName = senderName
        self.horizontalAlignment = horizontalAlignment
        self.deliveryStatus = deliveryStatus
    }
}

extension ChatCellDisplayData {
    public enum Content: Conformable  {
        public var id: Content { self }
        case text(_ text: String)
        case image(_ url: URL, _ ratio: CGFloat)
        case emoji(_ image: UIImage)
        case link(_ url: URL)
    }
}
extension HorizontalAlignment: @retroactive Hashable {
    public func hash(into hasher: inout Hasher) {
        self.key.hash(into: &hasher)
    }
}
