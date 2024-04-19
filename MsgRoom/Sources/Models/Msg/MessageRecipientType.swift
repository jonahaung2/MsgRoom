//
//  MsgRecipientType.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 6/4/24.
//

import SwiftUI

enum MessageRecipientType: Int, Hashable, Identifiable, Sendable, CaseIterable {
    var id: Int { rawValue }
    case Send
    case Receive
    var hAlignment: HorizontalAlignment { self == .Send ? .trailing : .leading }
}
