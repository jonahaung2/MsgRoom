//
//  MsgRoomAction.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 8/7/24.
//

import UIKit
public struct MsgRoomAction: Sendable {
    public let item: ActionItem
    public var data: Sendable?
    public init(item: ActionItem, data: Sendable? = nil) {
        self.item = item
        self.data = data
    }
}

public extension MsgRoomAction {
    enum ActionItem: Sendable {
        case sendMsg(SendMsg)
        case sendReaction(SendReaction)
        case sendDeliveryStatus(_ status: MsgDeliveryStatus, to: Msg)
        case openAIRequest(_ request: OpenAIClient.Prompt.ask(input: text))
        public enum SendMsg: Sendable {
            case text(String)
            case emoji(String)
            case images([URL])
            case video(URL)
            case msg(Msg)
        }
        public enum UpdateMsg: Sendable {
            case deliveryStatus(MsgDeliveryStatus)
        }
        public enum SendReaction: Sendable {
            case react(String)
        }
    }
}
