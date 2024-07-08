//
//  CoreDataStack.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 8/7/24.
//

import CoreData

final class CoreDataStack: NSObject {
    
    let container: NSPersistentContainer
    
    private(set) lazy var backgroundContext: NSManagedObjectContext = {
        $0.persistentStoreCoordinator = self.container.persistentStoreCoordinator
        return $0
    }(NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType))
    private(set) lazy var viewContext: NSManagedObjectContext = {
        $0.parent = self.backgroundContext
        return $0
    }(NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType))
    
    override init() {
        container = .init(name: SharedDatabase.modelName)
        super.init()
        if let description = container.persistentStoreDescriptions.first {
            description.url = SharedDatabase.coredataURL
            description.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
        }
        container.loadPersistentStores { description, error in
            if let error {
                fatalError(error.localizedDescription)
            }
            self.container.viewContext.automaticallyMergesChangesFromParent = true
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
            if self.backgroundContext.hasChanges {
                do {
                    try self.backgroundContext.save()
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
