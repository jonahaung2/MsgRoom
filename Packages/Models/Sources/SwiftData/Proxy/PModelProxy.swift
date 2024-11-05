//
//  File.swift
//
//
//  Created by Aung Ko Min on 17/7/24.
//

import Foundation
import SwiftData

public protocol PModelProxy: Equatable, Hashable, Sendable {
    associatedtype Persistent: PersistentModel
    var persistentId: PersistentIdentifier? { get set }
    var id: String { get }
    mutating func asPersistentModel(in context: ModelContext) -> Persistent
    init(persisted: Persistent)
    func updating(persisted: Persistent)
}
