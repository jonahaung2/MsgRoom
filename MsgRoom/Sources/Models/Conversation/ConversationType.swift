//
//  RoomType.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 6/4/24.
//

import Foundation
enum ConversationType {
    typealias ContactItem = any Contactable
    case single(ContactItem)
    case group([ContactItem])
}
