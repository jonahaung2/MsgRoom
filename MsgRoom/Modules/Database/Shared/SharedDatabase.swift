//
//  SharedDatabase.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 28/6/24.
//

import Foundation

enum SharedDatabase {
    static let coredataURL = URL.documentsDirectory.appending(path: "msgRoom.CoreData")
    static let swiftDataURL = URL.documentsDirectory.appending(path: "msgRoom.CoreData")
    static let modelName = "MsgRoom"
}
