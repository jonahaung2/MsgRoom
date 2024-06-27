//
//  CoreDataStack.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 26/6/24.
//

import Foundation
import CoreData

final class CoreDataStack {
    
    private let modelName: String
    
    init(modelName: String) {
        self.modelName = modelName
    }
    private lazy var privateManagedObjectContext: NSManagedObjectContext = {
        let x = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        x.persistentStoreCoordinator = self.coordinator
        return x
    }()
    private(set) lazy var viewContext: NSManagedObjectContext = {
        let x = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        x.parent = self.privateManagedObjectContext
        return x
    }()
    private lazy var managedObjectModel: NSManagedObjectModel = {
        guard let url = Bundle.main.url(forResource: self.modelName, withExtension: "momd") else { fatalError() }
        guard let x = NSManagedObjectModel(contentsOf: url) else { fatalError() }
        return x
    }()
    private lazy var coordinator: NSPersistentStoreCoordinator = {
        let x = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let fileManager = FileManager.default
        let storeName = "\(modelName).sqlite"
        let directory = fileManager.containerURL(forSecurityApplicationGroupIdentifier: Configurations.group_name)!
        let storeUrl =  directory.appendingPathComponent(storeName)
        do {
            let options = [
                NSMigratePersistentStoresAutomaticallyOption : true,
                NSInferMappingModelAutomaticallyOption : true,
            ]
            try x.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeUrl, options: options)
        } catch {
            fatalError()
        }
        return x
    }()
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
