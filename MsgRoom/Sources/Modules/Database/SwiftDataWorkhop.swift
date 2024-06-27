//
//  Database.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 26/6/24.
//

import Foundation
import SwiftData

public protocol SwiftDataWorkhop {
    func delete<T>(_ model: T) async where T: PersistentModel
    func insert<T>(_ model: T) async where T: PersistentModel
    func save() async throws
    func fetch<T>(_ descriptor: FetchDescriptor<T>) async throws -> [T] where T: PersistentModel
    
    func delete<T: PersistentModel>(
        where predicate: Predicate<T>?
    ) async throws
}

public extension SwiftDataWorkhop {
    func fetch<T: PersistentModel>(
        where predicate: Predicate<T>?,
        sortBy: [SortDescriptor<T>]
    ) async throws -> [T] {
        try await self.fetch(FetchDescriptor<T>(predicate: predicate, sortBy: sortBy))
    }
    
    func fetch<T: PersistentModel>(
        _ predicate: Predicate<T>,
        sortBy: [SortDescriptor<T>] = []
    ) async throws -> [T] {
        try await self.fetch(where: predicate, sortBy: sortBy)
    }
    
    func fetch<T: PersistentModel>(
        _: T.Type,
        predicate: Predicate<T>? = nil,
        sortBy: [SortDescriptor<T>] = []
    ) async throws -> [T] {
        try await self.fetch(where: predicate, sortBy: sortBy)
    }
    
    func delete<T: PersistentModel>(
        model _: T.Type,
        where predicate: Predicate<T>? = nil
    ) async throws {
        try await self.delete(where: predicate)
    }
}
