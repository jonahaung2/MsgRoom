//
//  Room.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 29/6/24.
//

import Foundation
import SwiftData
import XUI
import MsgRoomCore

@Model
final class Room: RoomRepresentable {
    @Attribute(.unique)
    let id: String
    var name: String
    var type: RoomType
    var createdDate: Date
    var photoURL: String?
    var contacts = [Contact]()
    var lastMsg: LastMsg?
    
    init(id: String, name: String, type: RoomType, createdDate: Date, photoURL: String? = nil) {
        self.id = id
        self.name = name
        self.type = type
        self.createdDate = createdDate
        self.photoURL = photoURL
    }
}
extension Room {
    
    static func create(id: String, date: Date, name: String, photoUrl: String, type: RoomType) async throws -> (any RoomRepresentable)? {
        Room.init(id: id, name: name, type: type, createdDate: date, photoURL: photoUrl)
    }
    
    func safeObject() async -> Self {
        @Injected(\.swiftDatabase) var swiftDatabase
        return await swiftDatabase.actor.model(for: self.persistentModelID)
    }
    
    func msgs<T>() -> [T] where T : MsgRepresentable {
        @Injected(\.coreDataContainer) var container
        let request = Msg.fetchRequest()
        request.predicate = .init(format: "conID == %@", self.id)
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        do {
            let results = try container.viewContext.fetch(request)
            return results as! [T]
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
}
