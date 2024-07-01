//
//  MsgRoom.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 25/6/24.
//

import SwiftUI
import SecureStorage
import XUI
import SwiftData

struct MsgRoom {
    
    var incomingSocket = IncomingSocket()
    var outgoingSocket = OutgoingSocket()
    var coreDataContainer: CoreDataContainer
    var coreDataStore: CoreDataStore
    var secureStorage = SecureStorage(suiteName: AppConfig.group_name)!
    var swiftDatabase: SwiftDatabase
    
    init() {
        if !secureStorage.isKeyCreated {
            secureStorage.password = UUID().uuidString
        }
        coreDataContainer = CoreDataContainer(modelName: SharedDatabase.modelName)
        coreDataStore = .init(mainContext: coreDataContainer.viewContext)
        do {
            swiftDatabase = try SwiftDatabase()
        } catch {
            fatalError()
        }
    }
}
