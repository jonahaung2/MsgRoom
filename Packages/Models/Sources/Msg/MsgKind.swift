//
//  MsgType.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 6/4/24.
//

import Foundation

public enum MsgKind: Int, Conformable, Codable {
    public var id: Self { self }
    case Text, Image, Video, Location, Emoji, Attachment, Voice
}
