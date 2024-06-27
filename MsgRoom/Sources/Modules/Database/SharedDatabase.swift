//
//  SharedDatabase.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 26/6/24.
//

import CoreData
import SwiftData

public struct SharedDatabase {
    
    public static var container: ModelContainer = {
        let configuration = ModelConfiguration(isStoredInMemoryOnly: false, allowsSave: true)
        do {
            let container = try ModelContainer(
                for: Message.self, Contact.self, Conversation.self,
                configurations: configuration
            )
            return container
        } catch {
            fatalError()
        }
    }()
    public static let shared: SharedDatabase = .init(schemas: [Message.self, Conversation.self, Contact.self], modelContainer: container)
    
    public let schemas: [any PersistentModel.Type]
    public let modelContainer: ModelContainer
    public let workshop: any SwiftDataWorkhop
    
    private init(
        schemas: [any PersistentModel.Type],
        modelContainer: ModelContainer,
        database: (any SwiftDataWorkhop)? = nil
    ) {
        self.schemas = schemas
        self.modelContainer = modelContainer
        self.workshop = MainWorkshop(modelContainer: modelContainer)
    }
}
