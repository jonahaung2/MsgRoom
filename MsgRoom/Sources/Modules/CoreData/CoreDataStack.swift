//
//  CoreDataStack.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 26/6/24.
//

import Foundation
import CoreData

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
final class CoreDataStack {

    static let shared = CoreDataStack(modelName: "Msgr")

    private let modelName: String

    init(modelName: String) {
        self.modelName = modelName
    }
    private lazy var privateManagedObjectContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.persistentStoreCoordinator = self.persistantStoreCoordinator
        return context
    }()

    private(set) lazy var viewContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.parent = self.privateManagedObjectContext
        return context
    }()

    private lazy var managedObjectModel: NSManagedObjectModel = {
        guard let dataModelUrl = Bundle.main.url(forResource: self.modelName, withExtension: "momd") else { fatalError("unable to find data model url") }
        guard let dataModel = NSManagedObjectModel(contentsOf: dataModelUrl) else { fatalError("unable to find data model") }
        return dataModel
    }()

    private lazy var persistantStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let fileManager = FileManager.default
        let storeName = "\(modelName).sqlite"
        let directory = fileManager.containerURL(forSecurityApplicationGroupIdentifier: "group.com.aungkomin.Msgr.v3")!
        let storeUrl =  directory.appendingPathComponent(storeName)
        do {
            let options = [
                NSMigratePersistentStoresAutomaticallyOption : true,
                NSInferMappingModelAutomaticallyOption : true,
            ]
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeUrl, options: options)
        } catch {
            fatalError("unable to add store")
        }
        return coordinator
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
