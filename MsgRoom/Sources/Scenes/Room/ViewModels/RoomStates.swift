//
//  MsgRoomSettings.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 19/4/24.
//

import Foundation

struct RoomStates {
    var scrollItem: ScrollItem?
    var scrollViewFrame = CGRect.zero
    var showScrollToLatestButton = false
    var selectedId: String?
    var focusId: String?
}
