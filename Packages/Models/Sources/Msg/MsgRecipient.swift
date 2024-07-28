//
//  MsgRecipientType.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 6/4/24.
//

import SwiftUI

public enum MsgRecipient: Int, Conformable, CaseIterable, Codable {
    public var id: Int { rawValue }
    case Send
    case Receive
    public var hAlignment: HorizontalAlignment { self == .Send ? .trailing : .leading }
}
