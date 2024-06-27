//
//  ModelActorDatabase.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 26/6/24.
//

import Foundation
import SwiftData

@ModelActor
public actor MainWorkshop: SwiftDataWorkhop {
    public func delete(_ model: some PersistentModel) async {
        self.modelContext.delete(model)
    }
    
    public func insert(_ model: some PersistentModel) async {
        self.modelContext.insert(model)
    }
    
    public func delete<T: PersistentModel>(
        where predicate: Predicate<T>?
    ) async throws {
        try self.modelContext.delete(model: T.self, where: predicate)
    }
    
    public func save() async throws {
        try self.modelContext.save()
    }
    
    public func fetch<T>(_ descriptor: FetchDescriptor<T>) async throws -> [T] where T: PersistentModel {
        return try self.modelContext.fetch(descriptor)
    }
}
