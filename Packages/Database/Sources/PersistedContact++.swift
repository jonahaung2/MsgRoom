//
//  File.swift
//  
//
//  Created by Aung Ko Min on 29/7/24.
//

import Foundation
import Models
import Database

public extension PersistedContact {
    @MainActor
    static func fetch(for id: String) -> Contact? {
        if let cached = PersistedContact.cache[id] {
            return cached
        }
        @Injected(\.swiftDatabase) var database
        do {
            let existings = try database.container.mainContext.fetch(.init(predicate: #Predicate<PersistedContact>{ model in
                model.id == id
            }))
            if let first = existings.first {
                return .init(persisted: first)
            }
            return nil
        } catch {
            return nil
        }
    }
}
