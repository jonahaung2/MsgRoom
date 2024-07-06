//
//  MsgRoom.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 25/6/24.
//

import SwiftUI
import XUI

struct MsgRoom {

    var coreDataContainer: CoreDataContainer
    var coreDataStore: CoreDataStore
    var dataModel: DataModel
    var incomingSocket = IncomingSocket()
    var outgoingSocket = OutgoingSocket()
    
    init() {
        coreDataContainer = CoreDataContainer(modelName: SharedDatabase.modelName)
        coreDataStore = .init(mainContext: coreDataContainer.viewContext)
        dataModel = DataModel.shared
    }
}
