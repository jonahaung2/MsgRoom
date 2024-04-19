//
//  MsgRoomSettings.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 19/4/24.
//

import Foundation

class MsgRoomSettings: ObservableObject {
    @Published var scrollItem: ScrollItem?
    @Published var selectedId: String?
    @Published var focusedId: String?
    @Published var showScrollToLatestButton = false
}
