//
//  MsgReactionType.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 6/4/24.
//

import Foundation
import XUI

public struct MessageReactionType: RawRepresentable, Conformable, ExpressibleByStringLiteral {
    public var id: String { rawValue }
    public let rawValue: String
    
    public init(rawValue: String) {
        self.rawValue = rawValue
    }
    public init(stringLiteral: String) {
        self.init(rawValue: stringLiteral)
    }
}
