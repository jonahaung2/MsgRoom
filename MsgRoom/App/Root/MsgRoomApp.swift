//
//  MsgRoomApp.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 12/3/24.
//

import SwiftUI
import SwiftData
import Database
import Core

@main
struct MsgRoomApp: App {
    
    let msgRoom = MsgRoom()
    let models = Models()
    
    @Environment(\.scenePhase) private var scenePhase
    
    init() {
        msgRoom.configure()
        models.configure()
    }
    var body: some Scene {
        mainScene
    }
    
    private var mainScene: some Scene {
        WindowGroup {
            MainTabView()
                .tint(Color("AccentColor"))
        }
        .modelContainer(models.dataModel.container)
    }
    private var otherScene: some Scene {
        WindowGroup {
            Text("hahah")
        }
        .modelContainer(models.dataModel.container)
    }
}
