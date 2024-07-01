//
//  ModelActorDatabase.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 29/6/24.
//

import Foundation
import SwiftData
import XUI

@ModelActor
public actor SwiftDataModelActor {
    
    private let lock = RecursiveLock()
    public func delete(_ model: some PersistentModel) {
        lock.sync {
            self.modelContext.delete(model)
        }
    }
    
    public func insert(_ model: some PersistentModel) {
        lock.sync {
            self.modelContext.insert(model)
        }
    }
    
    public func delete<T: PersistentModel>(
        where predicate: Predicate<T>?
    ) throws {
        try self.modelContext.delete(model: T.self, where: predicate)
    }
    
    public func save() async throws {
        try self.modelContext.save()
    }
    
    public func fetch<T>(_ descriptor: FetchDescriptor<T>) throws -> [T] where T: PersistentModel {
        let item = try self.modelContext.fetch(descriptor)
        return lock.sync {
            return item
        }
    }
    
    public func model<T>(for id: PersistentIdentifier) -> T where T: PersistentModel {
        return lock.sync {
            return modelContext.model(for: id) as! T
        }
    }
}
