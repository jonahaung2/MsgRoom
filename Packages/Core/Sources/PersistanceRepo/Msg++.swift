//
//  File.swift
//  
//
//  Created by Aung Ko Min on 29/7/24.
//

import Foundation
import Models

public extension Msg {
    @MainActor func sender() -> Contact? {
        PersistedContact.fetch(for: senderID)
    }
}
