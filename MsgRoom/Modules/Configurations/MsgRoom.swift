//
//  MsgRoom.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 25/6/24.
//

import SwiftUI
import XUI

struct MsgRoom {
    
    var dataModel: SwiftDataStore
    var incomingSocket = IncomingSocket()
    var outgoingSocket = OutgoingSocket()
    var swiftdataRepo: SwiftDataRepository
    
    init() {
        dataModel = SwiftDataStore.shared
        swiftdataRepo = .init(container: dataModel.container)
    }
}
