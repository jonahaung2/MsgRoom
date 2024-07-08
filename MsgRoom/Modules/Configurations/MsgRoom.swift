//
//  MsgRoom.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 25/6/24.
//

import SwiftUI
import XUI

struct MsgRoom {
    
    var dataModel: DataModel
    var incomingSocket = IncomingSocket()
    var outgoingSocket = OutgoingSocket()
    var coredataRepo: CoreDataRepository
    var coredataStack = CoreDataStack()
    
    init() {
        dataModel = DataModel.shared
        coredataRepo = .init(context: coredataStack.backgroundContext)
    }
}
