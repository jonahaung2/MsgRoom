//
//  RoomData.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 14/7/24.
//
import Foundation
import SwiftData
import XUI

@Model
final class PersistedRoom: IdentifiableByProxy {
    @Attribute(.unique) var id: String
    var name: String
    var type: RoomType
    var createdDate: Date
    var photoURL: String?
    var lastMsg: LastMsg?
    
    @Relationship var contacts: [PersistedContact]?
    
    init(id: String, name: String, type: RoomType, createdDate: Date, photoURL: String? = nil) {
        self.id = id
        self.name = name
        self.type = type
        self.createdDate = createdDate
        self.photoURL = photoURL
    }
}

extension PersistedRoom {
    @MainActor
    static func fetch(for id: String, context: ModelContext) -> PersistedRoom? {
        
        var descriptor = FetchDescriptor<PersistedRoom>(
            predicate: #Predicate { $0.id == id },
            sortBy: [
                .init(\.createdDate)
            ]
        )
        descriptor.fetchLimit = 50
        descriptor.includePendingChanges = true
        do {
            let existings = try context.fetch(descriptor)
            return existings.first
        } catch {
            Log(error)
            return nil
        }
    }
}
