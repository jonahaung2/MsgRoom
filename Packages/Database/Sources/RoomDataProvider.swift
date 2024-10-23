//
//  MsgDatasourceProviding.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 8/7/24.
//

import Foundation
import Models

public protocol RoomDataProvider {
    var room: MsgRoom { get set }
    @MainActor func loadInitialMsgs(for i: Int) -> [MsgRoomMsg]
    func loadMoreMsgsIfNeeded(for i: Int) -> [MsgRoomMsg]
}
