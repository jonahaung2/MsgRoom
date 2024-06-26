//
//  CoreDataStore.swift
//  Msgr
//
//  Created by Aung Ko Min on 6/11/22.
//

import Foundation
import CoreData
import XUI

actor CoreDataStore: Sendable {
    
    private let mainContext: NSManagedObjectContext
    private let backgroundContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
    
    private let queue: OperationQueue = {
        $0.name = "CoreDataStore"
        $0.maxConcurrentOperationCount = 1
        $0.qualityOfService = .userInitiated
        return $0
    }(OperationQueue())
    
    init(mainContext: NSManagedObjectContext) {
        self.mainContext = mainContext
        backgroundContext.parent = self.mainContext
    }
}

// Msg
extension CoreDataStore {
    func create<T>() -> T where T: NSManagedObject {
        T(context: backgroundContext)
    }
    func insert<T>(model: T, informSavedNotification: Bool) async throws where T: NSManagedObject {
        queue.addOperation {
//            self.backgroundContext.insert(model)
            NSManagedObjectContext.sync(context: self.backgroundContext)
        }
    }
    func mainObject<T>(with objectID: NSManagedObjectID) -> T? where T: NSManagedObject {
        if let existing = try? mainContext.existingObject(with: objectID) {
            return existing as? T
        }
        return mainContext.object(with: objectID) as? T
    }
}
