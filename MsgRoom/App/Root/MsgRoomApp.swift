//
//  MsgRoomApp.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 12/3/24.
//

import SwiftUI
import SwiftData
import MsgRoomCore

@main
struct MsgRoomApp: App {
    
    let msgRoom = MsgRoom()
    let msgRoomCore = MsgRoomCore()
    init() {
        msgRoom.configure()
        msgRoomCore.configure()
    }
    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
        .modelContainer(msgRoom.dataModel.container)
    }
}
