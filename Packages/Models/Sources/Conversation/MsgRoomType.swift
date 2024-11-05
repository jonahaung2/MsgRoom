//
//  RoomType.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 6/4/24.
//

import Foundation

public enum MsgRoomType: Int, Conformable, Codable {
    case single, group
    public var id: Int { rawValue }
}
