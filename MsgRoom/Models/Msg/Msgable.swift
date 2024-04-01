//
//  MsgRepresentable.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 12/3/24.
//

import SwiftUI

protocol Msgable: ObservableObject, Hashable, Identifiable, Equatable, Codable {
    var conId: String { get }
    var date: Date { get }
    var id: String { get }
    var deliveryStatus_: Int16 { get set }
    var msgType_: Int16 { get }
    var progress: Int16 { get }
    var senderId: String { get }
    var text: String { get }
    init(conId: String, date: Date, id: String, deliveryStatus_: Int16, msgType_: Int16, progress: Int16, senderId: String, text: String)
}

extension Msgable {
    var msgType: MsgType {
        .init(rawValue: msgType_) ?? .Text
    }
    var recieptType: MsgRecipientType {
        senderId == CurrentUser.id ? .Send : .Receive
    }
    var deliveryStatus: MsgDeliveryStatus {
        get { .init(rawValue: deliveryStatus_) ?? .Sent }
        set { deliveryStatus_ = newValue.rawValue }
    }
}

// Models
enum MsgDeliveryStatus: Int16, CustomStringConvertible {
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
enum MsgType: Int16 {
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
