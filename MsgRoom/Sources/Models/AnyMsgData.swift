//
//  AnyMsgData.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 25/6/24.
//

import Foundation
import XUI

enum AnyMsgData: Hashable, Sendable {
    
    typealias Msg = any Msg_
    typealias Con = any Conversation_
    
    case newMsg(Msg)
    case updatedMsg(Msg)
    case typingStatus(TypingStatus)
    
    static func == (lhs: AnyMsgData, rhs: AnyMsgData) -> Bool {
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
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case .newMsg(let msg):
            msg.hash(into: &hasher)
        case .updatedMsg(let msg):
            msg.hash(into: &hasher)
        case .typingStatus(let bool):
            bool.hash(into: &hasher)
        }
    }
    var conId: String {
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
        let id: String
        let conId: String
        let isTyping: String
    }
}
