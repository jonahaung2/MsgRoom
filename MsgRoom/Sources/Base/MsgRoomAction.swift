//
//  MsgRoomAction.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 8/7/24.
//

import UIKit

public struct MsgRoomAction: Sendable {
    let item: ActionItem
    var data: Sendable?
}

extension MsgRoomAction {
    enum ActionItem: Sendable {
        case sendMsg(SendMsg)
        case sendReaction(SendReaction)
        
        public enum SendMsg: Sendable {
            case text(String)
            case emoji(String)
            case images([URL])
            case video(URL)
        }
        
        public enum SendReaction: Sendable {
            case react(String)
        }
    }
}
