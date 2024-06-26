//
//  MsgDeliveryStatus.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 6/4/24.
//

import Foundation
import XUI
@objc
public enum MsgDelivery: Int, Conformable, CaseIterable {
    public var id: Int { rawValue }
    case Sending, Sent, SendingFailed, Received, Read
    public var description: String {
        switch self {
        case .Sending: return "Sending"
        case .Sent: return "Sent"
        case .SendingFailed: return "Failed"
        case .Received: return "Received"
        case .Read: return "Read"
        }
    }
    public func iconName() -> String? {
        switch self {
        case .Sending: return "circlebadge"
        case .Sent: return "checkmark.circle.fill"
        case .SendingFailed: return "exclamationmark.circle.fill"
        default: return nil
        }
    }
}
