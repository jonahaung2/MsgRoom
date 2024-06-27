//
//  MsgRoom.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 25/6/24.
//

import SwiftUI
import SecureStorage
import XUI

struct MsgRoom {
    
    var storage = SecureStorage(suiteName: "group.jonahaung.msgRoom")!
    var incomingSocket = IncomingSocket()
    var outgoingSocket = OutgoingSocket()
    var database = SharedDatabase.shared
    
    init() {
        if !storage.isKeyCreated {
            storage.password = UUID().uuidString
        }
    }
}
