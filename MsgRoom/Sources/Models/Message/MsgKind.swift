//
//  MsgType.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 6/4/24.
//

import Foundation
import XUI

public enum MsgKind: Int, Conformable, Codable {
    public var id: Self { self }
    case Text
    case Image
    case Video
    case Location
    case Emoji
    case Attachment
    case Voice
}
