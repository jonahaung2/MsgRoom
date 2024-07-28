//
//  File.swift
//  
//
//  Created by Aung Ko Min on 17/7/24.
//

import Foundation
import SwiftData

public protocol PersistentModelProxy: Equatable, Hashable, Sendable {
    associatedtype Persistent: PersistentModel
    var persistentId: PersistentIdentifier? { get set }
    func asPersistentModel(in context: ModelContext) -> Persistent
    init(persisted: Persistent)
    func updating(persisted: Persistent)
}
