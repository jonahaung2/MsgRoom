//
//  RoomType.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 6/4/24.
//

import Foundation
import XUI

enum ConversationType: Int, Conformable, Codable {
    var id: Int {
        rawValue
    }
    case single
    case group
}
