//
//  RoomData.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 14/7/24.
//
import Foundation
import SwiftData

@Model
public final class PersistedRoom: IdentifiableByProxy {
    @Attribute(.unique) public var id: String
    public var name: String
    public var type: RoomType
    public var createdDate: Date
    public var photoURL: String?
    public var lastMsg: LastMsg?
    
    @Relationship public var contacts: [PersistedContact]?
    
    public init(id: String, name: String, type: RoomType, createdDate: Date, photoURL: String? = nil) {
        self.id = id
        self.name = name
        self.type = type
        self.createdDate = createdDate
        self.photoURL = photoURL
    }
}

public extension PersistedRoom {
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
            return nil
        }
    }
}
