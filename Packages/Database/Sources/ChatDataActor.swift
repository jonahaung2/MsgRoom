import Foundation
import SwiftData
import Models

public actor ChatDataActor: ModelActor {
    
    public nonisolated var modelContainer: ModelContainer {
        modelExecutor.modelContext.container
    }
    
    public var context: ModelContext {
        modelExecutor.modelContext
    }
    
    public let modelExecutor: ModelExecutor
    
    public init(container: ModelContainer) {
        let context = ModelContext(container)
        context.autosaveEnabled = false
        modelExecutor = DefaultSerialModelExecutor(modelContext: context)
    }
    
    public enum Failure: Error, Equatable, Hashable, Sendable {
        case unknown(NSError)
        case swiftData(SwiftDataError)
        case noPersistentId
        case noModelFoundForId(PersistentIdentifier)
        
        public var localizedDescription: String {
            switch self {
            case let .unknown(nsError):
                return nsError.localizedDescription
            case let .swiftData(swiftDataError):
                return swiftDataError.localizedDescription
            case .noPersistentId:
                return "PersistentIdentifier required but not found on proxy."
            case let .noModelFoundForId(id):
                return "No model found in context for id \(id.id) and entity \(id.entityName)."
            }
        }
    }
    
    public func create<T>(_ item: T) async -> Result<T, Failure> where T: PModelProxy {
        if let existing = try? await existed(item) {
            return .success(existing)
        }
        do {
            var item = item
            let repoItem = item.asPersistentModel(in: context)
            context.insert(repoItem)
            guard context.hasChanges else {
                debugPrint("no changes")
                return .success(T(persisted: repoItem))
            }
            try context.save()
            item.persistentId = repoItem.persistentModelID
            return .success(item)
        } catch let error as SwiftDataError {
            context.rollback()
            return .failure(.swiftData(error))
        } catch {
            context.rollback()
            return .failure(.unknown(error as NSError))
        }
    }
    
    public func read<T>(identifier: PersistentIdentifier, as _: T.Type) -> Result<T, Failure> where T: PModelProxy {
        guard let repoItem: T.Persistent = context.model(for: identifier) as? T.Persistent else {
            return .failure(.noModelFoundForId(identifier))
        }
        return .success(T(persisted: repoItem))
    }
    public func readSubscription<Proxy>(
        identifier: PersistentIdentifier, as _: Proxy.Type
    ) -> AsyncStream<Result<Proxy,Failure>> where Proxy: PModelProxy {
        guard let repoItem: Proxy.Persistent = context.model(for: identifier) as? Proxy.Persistent else {
            return AsyncStream(unfolding: { .failure(.noModelFoundForId(identifier)) })
        }
        return repoItem.subscription()
    }
    
    public func readThrowingSubscription<T>(
        identifier: PersistentIdentifier,
        as _: T.Type
    ) -> AsyncThrowingStream<T, Error> where T: PModelProxy {
        guard let repoItem: T.Persistent = context.model(for: identifier) as? T.Persistent else {
            return AsyncThrowingStream(unfolding: { throw Failure.noModelFoundForId(identifier) })
        }
        return repoItem.throwingSubscription()
    }
    
    public func update<T>(_ item: T) -> Result<T, Failure> where T: PModelProxy {
        guard let persistentId = item.persistentId else {
            return .failure(.noPersistentId)
        }
        guard let object = context.model(for: persistentId) as? T.Persistent else {
            return .failure(.noModelFoundForId(persistentId))
        }
        item.updating(persisted: object)
        guard context.hasChanges else {
            debugPrint("no changes")
            return .success(T(persisted: object))
        }
        do {
            try context.save()
            return .success(T(persisted: object))
        } catch let error as SwiftDataError {
            context.rollback()
            return .failure(.swiftData(error))
        } catch {
            context.rollback()
            return .failure(.unknown(error as NSError))
        }
    }
    
    public func delete(
        identifier: PersistentIdentifier
    ) -> Result<Void, Failure> {
        let object = context.model(for: identifier)
        context.delete(object)
        if !object.isDeleted {
            fatalError()
        }
        guard context.hasChanges else {
            debugPrint("no changes")
            return .success(())
        }
        do {
            try context.save()
            context.processPendingChanges()
            return .success(())
        } catch let error as SwiftDataError {
            context.rollback()
            return .failure(.swiftData(error))
        } catch {
            context.rollback()
            return .failure(.unknown(error as NSError))
        }
    }
    
    public func fetch<T: PModelProxy>(
        _ request: FetchDescriptor<T.Persistent>
    ) -> Result<[T], Failure> {
        do {
            return try .success(context.fetch(request).map(T.init(persisted:)))
        } catch let error as SwiftDataError {
            return .failure(.swiftData(error))
        } catch {
            return .failure(.unknown(error as NSError))
        }
    }
    public func fetch<T: PModelProxy>(id: String) -> T? where T.Persistent.ID == String {
        var descriptor = FetchDescriptor<T.Persistent>(
            predicate: #Predicate { $0.id == id }
        )
        descriptor.fetchLimit = 1
        if let persistent = try? context.fetch(descriptor).first {
            return T(persisted: persistent)
        }
        return nil
    }
    public func fetch<T: PModelProxy>(
        _ request: FetchDescriptor<T.Persistent>,
        batchSize: Int
    ) -> Result<[T], Failure> {
        do {
            return try .success(context.fetch(request, batchSize: batchSize).map(T.init(persisted:)))
        } catch let error as SwiftDataError {
            return .failure(.swiftData(error))
        } catch {
            return .failure(.unknown(error as NSError))
        }
    }
    func existed<T>(_ item: T) async throws -> T where T: PModelProxy {
        guard let identifier = item.persistentId else {
            throw Failure.noPersistentId
        }
        guard let _object: T.Persistent = context.model(for: identifier) as? T.Persistent else {
            throw Failure.noModelFoundForId(identifier)
        }
        return T(persisted: _object)
    }
    func verifyDoesNotExist<T>(_ item: T) async throws -> Bool where T: PModelProxy {
        return try await existed(item).persistentId == nil
    }
    func identifier<T>(for item: T) async throws -> PersistentIdentifier? where T: PModelProxy {
        return try await existed(item).persistentId
    }
}

extension PersistentModel {
    func subscription<T, Failure>() -> AsyncStream<Result<T, Failure>> where T: PModelProxy, T.Persistent == Self, Failure: Error {
        AsyncStream { continuation in
            continuation.yield(.success(T(persisted: self)))
            withObservationTracking {
                _ = self.hasChanges
            } onChange: {
                continuation.yield(.success(T(persisted: self)))
            }
        }
    }
    func throwingSubscription<T>() -> AsyncThrowingStream<T, Error> where T: PModelProxy, T.Persistent == Self {
        AsyncThrowingStream { continuation in
            continuation.yield(T(persisted: self))
            withObservationTracking {
                _ = self.hasChanges
            } onChange: {
                continuation.yield(T(persisted: self))
            }
        }
    }
}
