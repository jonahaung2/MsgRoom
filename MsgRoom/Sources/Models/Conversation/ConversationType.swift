//
//  RoomType.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 6/4/24.
//

import Foundation

enum ConversationType: Hashable, Identifiable, Codable {
    var id: ConversationType { self }
    case single(Contact)
    case group([Contact])
}
