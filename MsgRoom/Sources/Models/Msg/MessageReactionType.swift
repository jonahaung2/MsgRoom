//
//  MsgReactionType.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 6/4/24.
//

import Foundation

public struct MessageReactionType: RawRepresentable, Hashable, Identifiable, Sendable, ExpressibleByStringLiteral {
    public var id: String { rawValue }
    public let rawValue: String
    
    public init(rawValue: String) {
        self.rawValue = rawValue
    }
    public init(stringLiteral: String) {
        self.init(rawValue: stringLiteral)
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.init(
            rawValue: try container.decode(String.self)
        )
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rawValue)
    }
}
