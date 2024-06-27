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

    var storage = SecureStorage(suiteName: Configurations.group_name)!
    var incomingSocket = IncomingSocket()
    var outgoingSocket = OutgoingSocket()
    var phoneContacts = PhoneContacts()
    var coreDataStack: CoreDataStack
    var coreDataStore: CoreDataStore
    
    init() {
        if !storage.isKeyCreated {
            storage.password = UUID().uuidString
        }
        do {
            try phoneContacts.fetchContacts()
        } catch {
            Log(error)
        }
        coreDataStack = CoreDataStack.init(modelName: "MsgRoom")
        coreDataStore = .init(mainContext: coreDataStack.viewContext)
    }
}
