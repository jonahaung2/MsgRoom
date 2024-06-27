//
//  RoomType.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 6/4/24.
//

import Foundation
import XUI

@objc
public enum ConversationType: Int, Conformable {
    public var id: Int {
        rawValue
    }
    case single
    case group
}
