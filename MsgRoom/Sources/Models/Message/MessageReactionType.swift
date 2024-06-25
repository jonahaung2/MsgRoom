//
//  MsgReactionType.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 6/4/24.
//

import Foundation

public struct MessageReactionType: RawRepresentable, Comformable, ExpressibleByStringLiteral {
    public var id: String { rawValue }
    public let rawValue: String
    
    public init(rawValue: String) {
        self.rawValue = rawValue
    }
    public init(stringLiteral: String) {
        self.init(rawValue: stringLiteral)
    }
}
