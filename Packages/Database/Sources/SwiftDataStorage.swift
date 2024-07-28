//
//  SwiftDataStorage.swift
//
//
//  Created by Aung Ko Min on 23/7/24.
//

import Foundation
import OSLog
@_exported import SwiftData
import SwiftUI

@MainActor
@Observable
@propertyWrapper
public final class SwiftDataStorage<T: PersistentModel> {
    @ObservationIgnored
    lazy private var logger: Logger = {
        .init(
            subsystem: Bundle.main.bundleIdentifier ?? "Default Subsystem",
            category: String(describing: Self.self)
        )
    }()
    
    private var context: ModelContext? = nil
    private var objects: [T] = []
    
    public init() {}
    public var wrappedValue: [T] {
        get { objects }
        set { update(to: newValue) }
    }
    
    public func fetch(
        context: ModelContext,
        descriptor: FetchDescriptor<T> = .init()
    ) throws {
        self.context = context
        objects = try context.fetch(descriptor)
    }
    public func append(_ object: T) {
        guard let context else {
            logger.warning("modelContext must be set before calling append")
            return
        }
        guard !objects.contains(where: { $0.id == object.id }) else {
            logger.warning("attempt to append a duplicate object")
            return
        }
        context.insert(object)
        objects.append(object)
    }
    
    public func append(_ objectsToAppend: [T]) {
        objectsToAppend.forEach { append($0) }
    }
    public func remove(_ object: T) {
        guard let context else {
            logger.warning("modelContext must be set before calling remove")
            return
        }
        context.delete(object)
        objects = objects.filter { $0.id != object.id }
    }
    public func remove(_ objectsToRemove: [T]) {
        objectsToRemove.forEach { remove($0) }
    }
    public func removeAll(
        where predicate: Predicate<T>? = nil,
        includeSubclasses: Bool = true
    ) throws {
        guard let context else {
            logger.warning("modelContext must be set before calling removeAll")
            return
        }
        try context.delete(
            model: T.self,
            where: predicate,
            includeSubclasses: includeSubclasses
        )
        objects = []
    }
    private func update(to objects: [T]) {
        let newSet = Set(objects)
        let localSet = Set(self.objects)
        
        let objectsToAppend = Array(newSet.subtracting(localSet))
        let objectsToRemove = Array(localSet.subtracting(newSet))
        
        append(objectsToAppend)
        remove(objectsToRemove)
    }
}
