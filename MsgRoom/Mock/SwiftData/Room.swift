//
//  Room.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 29/6/24.
//

import Foundation
import SwiftData
import XUI
import CoreData

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
    func msgs<T>() async throws -> [T] where T : MsgRepresentable {
        @Injected(\.coredataRepo) var repo
        let request = RepoMsg.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \RepoMsg.date, ascending: false)]
        request.predicate = .init(format: "conID == %@", self.id)
        switch await repo.fetch(request, as: Msg.self) {
        case .success(let items):
            return items as! [T]
        case .failure(let error):
            throw error
        }
    }
    func msgs<T>() -> [T] where T : MsgRepresentable {
        @Injected(\.coredataRepo) var repo
        let request = RepoMsg.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \RepoMsg.date, ascending: false)]
        request.predicate = .init(format: "conID == %@", self.id)
        do {
            let results = try repo.context.fetch(request)
            let managed = results.compactMap{ try?  Msg(managed: $0) }
            return managed as! [T]
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
}
