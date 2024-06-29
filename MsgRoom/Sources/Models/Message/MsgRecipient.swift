//
//  MsgRecipientType.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 6/4/24.
//

import SwiftUI
import XUI

public enum MsgRecipient: Int, Conformable, CaseIterable {
    public var id: Int { rawValue }
    case Send
    case Receive
    public var hAlignment: HorizontalAlignment { self == .Send ? .trailing : .leading }
}
