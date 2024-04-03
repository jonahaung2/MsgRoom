//
//  MsgRepresentable.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 12/3/24.
//

import SwiftUI

protocol Msgable: AnyObject, Hashable, Observable {
    
    typealias Sender = any Contactable
    
    var id: String { get }
    var conId: String { get }
    var msgType: MsgType { get }
    var sender: Sender? { get }
    var date: Date { get }
    var deliveryStatus: MsgDeliveryStatus { get set }
    var progress: Int16 { get }
    var text: String { get }
    
    init(conId: String, date: Date, id: String, deliveryStatus: MsgDeliveryStatus, msgType: MsgType, progress: Int16, sender: Sender, text: String)
}

extension Msgable {
    var recieptType: MsgRecipientType {
        sender?.id == CurrentUser.id ? .Send : .Receive
    }
}

// Models
enum MsgDeliveryStatus: Int16, CustomStringConvertible, CaseIterable {
    case Sending, Sent, SendingFailed, Received, Read
    var description: String {
        switch self {
        case .Sending: return "Sending"
        case .Sent: return "Sent"
        case .SendingFailed: return "Failed"
        case .Received: return "Received"
        case .Read: return "Read"
        }
    }
    func iconName() -> String? {
        switch self {
        case .Sending: return "circlebadge"
        case .Sent: return "checkmark.circle.fill"
        case .SendingFailed: return "exclamationmark.circle.fill"
        default: return nil
        }
    }
}
enum MsgRecipientType: Int16 {
    case Send
    case Receive
    var hAlignment: HorizontalAlignment { self == .Send ? .trailing : .leading }
}
enum MsgType: Int16, Hashable {
    case Text
    case Image
    case Video
    case Location
    case Emoji
    case Attachment
    case Voice
}

public struct MsgReactionType: RawRepresentable, Codable, Hashable, ExpressibleByStringLiteral {
    public let rawValue: String
    
    public init(rawValue: String) {
        self.rawValue = rawValue
    }
    
    public init(stringLiteral: String) {
        self.init(rawValue: stringLiteral)
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.init(
            rawValue: try container.decode(String.self)
        )
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rawValue)
    }
}
