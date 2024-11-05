//
//  Models.swift
//  
//
//  Created by Aung Ko Min on 22/7/24.
//

import Foundation
import SwiftData

public class ChatData {
    public var dataStore: ChatDataContainer
    public var swiftdataRepo: ChatDataActor
    public init() {
        dataStore = ChatDataContainer()
        swiftdataRepo = .init(container: dataStore.container)
    }
    
    public static let shared = ChatData()
    
    @MainActor public var modelContainer: ModelContainer { dataStore.container }
}
