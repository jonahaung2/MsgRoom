//
//  MsgRecipientType.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 6/4/24.
//

import SwiftUI

public enum MessageRecipientType: Int, Hashable, Identifiable, Sendable, CaseIterable {
    public var id: Int { rawValue }
    case Send
    case Receive
    var hAlignment: HorizontalAlignment { self == .Send ? .trailing : .leading }
}
