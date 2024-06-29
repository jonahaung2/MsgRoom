//
//  SectionedQuery.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 29/6/24.
//

import Foundation
import SwiftData
import SwiftUI

@propertyWrapper
struct SectionedQuery<SectionIdentifier, Result>: DynamicProperty
where SectionIdentifier: Hashable, Result: PersistentModel {
    
    private let sectionIdentifier: KeyPath<Result, SectionIdentifier>
    @Query private var results: [Result]
    
    var wrappedValue: SectionedResults<SectionIdentifier, Result> {
        SectionedResults(
            sectionIdentifier: sectionIdentifier,
            results: results
        )
    }
    
    init<Value>(
        _ sectionIdentifier: KeyPath<Result, SectionIdentifier>,
        filter: Predicate<Result>? = nil,
        sort keyPath: KeyPath<Result, Value>,
        order: SortOrder = .forward,
        animation: Animation = .default
    ) where Value: Comparable {
        self.sectionIdentifier = sectionIdentifier
        _results = Query(
            filter: filter,
                         sort: keyPath,
                         order: order,
                         animation: animation
        )
    }
    
}
