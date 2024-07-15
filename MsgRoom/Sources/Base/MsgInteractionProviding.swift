//
//  MsgInteractionProviding.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 8/7/24.
//

import Foundation
protocol MsgInteractionProviding {
    var room: Room { get }
    
    init(_ room: Room)
    func sendAction(_ action: MsgRoomAction)
}
