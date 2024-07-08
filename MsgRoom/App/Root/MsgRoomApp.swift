//
//  MsgRoomApp.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 12/3/24.
//

import SwiftUI
import SwiftData

@main
struct MsgRoomApp: App {
    
    let msgRoom = MsgRoom()
    @Environment(\.scenePhase) private var scenePhase
    init() {
        msgRoom.configure()
    }
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .tint(Color("AccentColor"))
        }
        .modelContainer(msgRoom.dataModel.container)
    }
}
