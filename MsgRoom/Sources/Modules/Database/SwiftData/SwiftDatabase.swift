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
    public let actor: SModelActor
    
    init() throws {
        let config = ModelConfiguration(url: SharedDatabase.swiftDataURL)
        container = try ModelContainer(for: Contact.self, Room.self, configurations: config)
        actor = SModelActor(modelContainer: container)
    }
}
