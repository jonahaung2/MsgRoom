//
//  Models.swift
//  
//
//  Created by Aung Ko Min on 22/7/24.
//

import Foundation

public class SwiftDatabase {
    public var dataModel: SwiftDataStore
    public var swiftdataRepo: SwiftDataRepository
    public init() {
        dataModel = SwiftDataStore()
        swiftdataRepo = .init(container: dataModel.container)
    }
    public static let shared = SwiftDatabase()
}
