//
//  MsgInteractionProviding.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 8/7/24.
//

import Foundation
import Models

public protocol ChatInteractionsConformation {
    var room: MsgRoom { get }
    init(_ room: MsgRoom)
    func sendAction(_ action: MsgRoomAction)
}
  
