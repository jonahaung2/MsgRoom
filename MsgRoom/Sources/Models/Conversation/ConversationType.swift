//
//  RoomType.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 6/4/24.
//

import Foundation
enum ConversationType: Comformable {
    var id: String {
        switch self {
        case .single(let string):
            return string
        case .group(let array):
            return array.sorted().joined()
        }
    }
    case single(String)
    case group([String])
}
