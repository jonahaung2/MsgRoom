//
//  MsgReactionType.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 6/4/24.
//

import Foundation

struct MessageReactionType: RawRepresentable, Hashable, Identifiable, Sendable, ExpressibleByStringLiteral {
    var id: String { rawValue }
    let rawValue: String
    
    init(rawValue: String) {
        self.rawValue = rawValue
    }
    init(stringLiteral: String) {
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
