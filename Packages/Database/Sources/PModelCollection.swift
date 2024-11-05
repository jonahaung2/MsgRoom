//
//  SwiftDataStorage.swift
//
//
//  Created by Aung Ko Min on 23/7/24.
//

import Foundation
import OSLog
import SwiftData
import SwiftUI
import Models
import XUI

@MainActor
@Observable
@propertyWrapper
public final class PModelCollection<T: PModelProxy> {
    @ObservationIgnored lazy private var logger: Logger = {
        .init(
            subsystem: Bundle.main.bundleIdentifier ?? "Default Subsystem",
            category: String(describing: Self.self)
        )
    }()
    private var objects: [T] = []
    @ObservationIgnored
    private let repo = ChatData.shared.swiftdataRepo
    public init() {}
    public var wrappedValue: [T] {
        get { objects }
        set { update(to: newValue) }
    }
    @ObservationIgnored private let queue = AsyncQueue(concurrency: 1, delay: 0.2)
    public func fetch(
//        context: ModelContext,
        descriptor: FetchDescriptor<T.Persistent> = .init()
    ) async throws {
        try await self.queue.run {
            let result: Result<[T], ChatDataActor.Failure> = await self.repo.fetch(descriptor)
            switch result {
            case .success(let objects):
                await MainActor.run {
                    self.objects = objects
                }
            case .failure(let error):
                await MainActor.run {
                    self.logger.warning("\(error.localizedDescription)")
                }
            }
        }
//        self.context = context
//        objects = try context.fetch(descriptor)
    }
    public func append(_ object: T) {
//        guard let context else {
//            logger.warning("modelContext must be set before calling append")
//            return
//        }
//        guard !objects.contains(where: { $0.id == object.id }) else {
//            logger.warning("attempt to append a duplicate object")
//            return
//        }
//        context.insert(object)
//        objects.append(object)
    }
    
    public func append(_ objectsToAppend: [T]) {
        objectsToAppend.forEach { append($0) }
    }
    public func remove(_ object: T) {
//        guard let context else {
//            logger.warning("modelContext must be set before calling remove")
//            return
//        }
//        context.delete(object)
//        objects = objects.filter { $0.id != object.id }
    }
    public func remove(_ objectsToRemove: [T]) {
        objectsToRemove.forEach { remove($0) }
    }
    public func removeAll(
        where predicate: Predicate<T>? = nil,
        includeSubclasses: Bool = true
    ) throws {
//        guard let context else {
//            logger.warning("modelContext must be set before calling removeAll")
//            return
//        }
//        try context.delete(
//            model: T.self,
//            where: predicate,
//            includeSubclasses: includeSubclasses
//        )
//        objects = []
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
