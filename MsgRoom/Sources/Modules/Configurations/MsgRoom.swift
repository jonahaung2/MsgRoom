//
//  MsgRoom.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 25/6/24.
//
//
//  MsgRoom.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 1/4/24.
//
import SwiftUI
import SecureStorage
import XUI
import MsgRoomCore

struct MsgRoom {

    var coreDataContainer: CoreDataContainer
    var coreDataStore: CoreDataStore
    var secureStorage = SecureStorage(suiteName: AppConfig.group_name)!
    var dataModel: DataModel
    
    init() {
        if !secureStorage.isKeyCreated {
            secureStorage.password = UUID().uuidString
        }
        coreDataContainer = CoreDataContainer(modelName: SharedDatabase.modelName)
        coreDataStore = .init(mainContext: coreDataContainer.viewContext)
        dataModel = DataModel.shared
    }
}
