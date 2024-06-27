//
//  ScrollItem.swift
//  Msgr
//
//  Created by Aung Ko Min on 22/10/22.
//

import SwiftUI
struct ScrollItem: Hashable, Identifiable, Sendable {
    let id: String
    let anchor: UnitPoint
    var animate: Bool = false
}
