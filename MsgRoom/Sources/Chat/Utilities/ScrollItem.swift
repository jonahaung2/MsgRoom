//
//  ScrollItem.swift
//  Msgr
//
//  Created by Aung Ko Min on 22/10/22.
//

import SwiftUI
public struct ScrollItem: Hashable, Identifiable, Sendable {
    public let id: String
    public let anchor: UnitPoint
    public var animate: Bool = false
}
