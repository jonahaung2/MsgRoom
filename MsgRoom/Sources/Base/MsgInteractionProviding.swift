//
//  MsgInteractionProviding.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 8/7/24.
//

import Foundation
public protocol MsgInteractionProviding {
    var room: any RoomRepresentable { get }
    init(_ room: any RoomRepresentable)
    func sendAction(_ action: MsgRoomAction)
}
