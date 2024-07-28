//
//  MsgRoomSettings.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 19/4/24.
//

import Foundation

public struct RoomStates {
    public var scrollItem: ScrollItem?
    public var scrollViewFrame: CGRect
    public var showScrollToLatestButton: Bool
    public var selectedId: String?
    public var focusId: String?
    public init(scrollItem: ScrollItem? = nil, scrollViewFrame: CGRect = CGRect.zero, showScrollToLatestButton: Bool = false, selectedId: String? = nil, focusId: String? = nil) {
        self.scrollItem = scrollItem
        self.scrollViewFrame = scrollViewFrame
        self.showScrollToLatestButton = showScrollToLatestButton
        self.selectedId = selectedId
        self.focusId = focusId
    }
}
