//
//  CoreDataStack.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 26/6/24.
//

import Foundation
import CoreData
import XUI

final class CoreDataContainer {
    
    private let container: NSPersistentContainer
    
    private(set) lazy var privateManagedObjectContext: NSManagedObjectContext = {
        $0.persistentStoreCoordinator = self.container.persistentStoreCoordinator
        return $0
    }(NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType))
    private(set) lazy var viewContext: NSManagedObjectContext = {
        $0.parent = self.privateManagedObjectContext
        return $0
    }(NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType))
    
    init(modelName: String) {
        container = .init(name: modelName)
        if let description = container.persistentStoreDescriptions.first {
            description.url = SharedDatabase.coredataURL
            description.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
        }
        container.loadPersistentStores { description, error in
            if let error {
                fatalError(error.localizedDescription)
            }
        }
    }
    
    func save() {
        viewContext.perform {
            if self.viewContext.hasChanges {
                do {
                    try self.viewContext.save()
                } catch {
                    print("saving error : child : - \(error.localizedDescription)")
                }
            }
            if self.privateManagedObjectContext.hasChanges {
                do {
                    try self.privateManagedObjectContext.save()
                } catch {
                    print("saving error : child : - \(error.localizedDescription)")
                }
            }
            print("saved")
        }
    }
}
extension NSManagedObjectContext {
    static func sync(context: NSManagedObjectContext) {
        do {
            try context.save()
            if let parent = context.parent {
                self.sync(context: parent)
            }
        } catch {
            print(error)
        }
    }
}
