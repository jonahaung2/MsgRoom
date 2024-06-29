//
//  SectionedResults.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 29/6/24.
//

import Foundation
import SwiftData

struct SectionedResults<SectionIdentifier, Result>: RandomAccessCollection
where SectionIdentifier: Hashable, Result: PersistentModel {
    
    typealias Element  = Self.Section
    typealias Index    = Int
    typealias Iterator = IndexingIterator<Self>
    
    var elements: [Element]
    var startIndex: Index = 0
    var endIndex: Index { elements.count }
    
    subscript(position: Index) -> Element {
        elements[position]
    }
    
    init(sectionIdentifier: KeyPath<Result, SectionIdentifier>,
         results: [Result]) {
        let groupedResults = Dictionary(grouping: results) { result in
            result[keyPath: sectionIdentifier]
        }
        
        let identifiers = results.map { result in
            result[keyPath: sectionIdentifier]
        }.uniqued().lazyList
        
        self.elements = identifiers.compactMap { identifier in
            guard let elements = groupedResults[identifier] else { return nil }
            return Section(id: identifier, elements: elements)
        }
    }
    
    struct Section: RandomAccessCollection, Identifiable {
        typealias Element  = Result
        typealias ID       = SectionIdentifier
        typealias Index    = Int
        typealias Iterator = IndexingIterator<Self>
        
        var id: ID
        var elements: [Element]
        var startIndex: Index = 0
        var endIndex: Index { elements.count }
        
        subscript(position: Index) -> Element {
            elements[position]
        }
    }
}
