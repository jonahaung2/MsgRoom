//
//  MsgType.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 6/4/24.
//

import Foundation

enum MessageType: Int16, Hashable, Equatable {
    case Text
    case Image
    case Video
    case Location
    case Emoji
    case Attachment
    case Voice
}
