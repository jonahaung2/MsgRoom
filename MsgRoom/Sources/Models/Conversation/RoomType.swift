//
//  RoomType.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 6/4/24.
//

import Foundation
import XUI

public enum RoomType: Int, Conformable, Codable {
    case single, group
    public var id: Int { rawValue }
}
