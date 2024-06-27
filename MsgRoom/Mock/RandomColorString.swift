//
//  RandomColor.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 27/6/24.
//

import SwiftUI

private struct SeededRandomGenerator: RandomNumberGenerator {
    public init(seed: Int) {
        srand48(seed)
    }
    public func next() -> UInt64 {
        UInt64(drand48() * Double(UInt64.max))
    }
}
private extension Color {
    static var random: Color {
        var generator: RandomNumberGenerator = SystemRandomNumberGenerator()
        return random(using: &generator)
    }
    static func random(using generator: inout RandomNumberGenerator) -> Color {
        let red = Double.random(in: 0..<1, using: &generator)
        let green = Double.random(in: 0..<1, using: &generator)
        let blue = Double.random(in: 0..<1, using: &generator)
        return Color(red: red, green: green, blue: blue)
    }
}

public extension String {
    var color: Color {
        let seed = self.hashValue
        var generator: RandomNumberGenerator = SeededRandomGenerator(seed: seed)
        return .random(using: &generator)
    }
}
