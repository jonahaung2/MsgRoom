//
//  AnyMsgData.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 25/6/24.
//

import Foundation
import XUI

enum AnyMsgData: Hashable, Sendable {

    case newMsg(Msg)
    case updatedMsg(Msg)
    case typingStatus(TypingStatus)
    
    public static func == (lhs: AnyMsgData, rhs: AnyMsgData) -> Bool {
        switch (lhs, rhs) {
        case (.newMsg, .newMsg):
            return true
        case (.updatedMsg, .updatedMsg):
            return true
        case (.typingStatus, .typingStatus):
            return true
        default:
            return false
        }
    }

    public var conId: String {
        switch self {
        case .newMsg(let msg):
            return msg.conID
        case .updatedMsg(let msg):
            return msg.conID
        case .typingStatus(let typingStatus):
            return typingStatus.conId
        }
    }
}
extension AnyMsgData {
    struct TypingStatus: Conformable {
        public let id: String
        public let conId: String
        public let isTyping: String
    }
}
