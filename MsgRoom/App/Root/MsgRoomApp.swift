//
//  MsgRoomApp.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 12/3/24.
//

import SwiftUI

@main
struct MsgRoomApp: App {
  
    let msgRoom = MsgRoom()
    
    init() {
        msgRoom.configure()
    }
    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
        .modelContext(msgRoom.database.modelContainer.mainContext)
    }
}
