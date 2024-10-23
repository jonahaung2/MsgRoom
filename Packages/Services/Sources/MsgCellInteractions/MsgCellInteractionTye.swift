//
//  MsgCellInteractionTye.swift
//  MsgRoomMain
//
//  Created by Aung Ko Min on 23/10/24.
//

import Models
import Foundation

public enum MsgCellInteractionTye: Sendable, Equatable {
    case onTapMsg(ChatMsg)
    case onMarkMsg(ChatMsg)
    case onTapAvatar(ChatMsg)
    case onFocusMsgBubble(_ item: MsgCellFocusedItem)
}
