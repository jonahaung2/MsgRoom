//
//  RoomType.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 6/4/24.
//

import Foundation
enum ConversationType: Sendable {
    typealias ContactItem = any ContactRepresentable
    case single(ContactItem)
    case group([ContactItem])
}
