//
//  Models.swift
//  
//
//  Created by Aung Ko Min on 22/7/24.
//

import Foundation

public struct Models {
    public var dataModel: SwiftDataStore
    public var swiftdataRepo: SwiftDataRepository
    public init() {
        dataModel = SwiftDataStore()
        swiftdataRepo = .init(container: dataModel.container)
    }
}
public extension Models {
    func configure() {
        ModelsProviderKey.currentValue = Store(self)
    }
}

private struct ModelsProviderKey: InjectionKey {
    static var currentValue: Store<Models>?
}

extension InjectedValues {
    public var models: Store<Models> {
        get {
            guard let injected = Self[ModelsProviderKey.self] else { fatalError("App was not setup") }
            return injected
        }
        set { Self[ModelsProviderKey.self] = newValue }
    }
    public var swiftdataRepo: SwiftDataRepository {
        get { models.value.swiftdataRepo }
        set { models.value.swiftdataRepo = newValue  }
    }
    public var swiftDatabase: SwiftDataStore {
        get { models.value.dataModel }
        set { models.value.dataModel = newValue  }
    }
}
