//
//  SModelContainer.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 29/6/24.
//

import Foundation
import SwiftData

public actor SwiftDatabase {
    
    public let container: ModelContainer
    public let actor: SwiftDataModelActor
    
    init() throws {
        container = try ModelContainer(for: Contact.self, Room.self, migrationPlan: nil, configurations: .init(isStoredInMemoryOnly: false))
        actor = SwiftDataModelActor(modelContainer: container)
    }
}
