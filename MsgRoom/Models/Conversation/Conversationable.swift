//
//  ConRepresentable.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 12/3/24.
//

import SwiftUI
import XUI

protocol Conversationable: AnyObject, Hashable, Observable {
    var id: String { get }
    var bgImage_: Int16 { get set }
    var bubbleCornorRadius: Int16 { get set }
    var date: Date { get }
    var name: String { get }
    var photoUrl: String { get }
    var themeColor_: Int16 { get set }
    var members_: [String] { get set }
    init(id: String, bgImage_: Int16, bubbleCornorRadius: Int16, date: Date, name: String, photoUrl: String, themeColor_: Int16, members_: [String])
}

extension Conversationable {
    var members: [Contact.Payload] {
        get {
            var values = [Contact.Payload]()
            members_.forEach { mem in
                let member = Contact.Payload(id: mem, name: Lorem.firstName, phone: Lorem.emailAddress, photoURL: Lorem.url)
                values.append(member)
            }
            return values
        }
        set {
            members_ = newValue.compactMap{ $0.id }
        }
    }
    var type: RoomType {
        let filtered = members.filter{ $0.id != CurrentUser.id }
        guard !filtered.isEmpty else {
            return .single(.init(id: "", name: "", phone: "", photoURL: ""))
        }
        return filtered.count == 1 ? .single(filtered[0]) : .group(filtered)
    }
    
    var nameX: String {
        switch type {
        case .single(let x):
            return x.name
        case .group(let mbrs):
            return mbrs.map{ $0.name }.joined(separator: ", ")
        }
    }
    
    var themeColor: RoomTheme {
        get { RoomTheme(rawValue: themeColor_) ?? .Blue }
        set { themeColor_ = newValue.rawValue }
    }
    
    func bubbleColor(for msg: any Msgable) -> Color {
        return msg.recieptType == .Send ? themeColor.color : bgImage == .None ? ChatKit.textBubbleColorIncomingPlain : ChatKit.textBubbleColorIncoming
    }
    
    var bgImage: RoomBgImage {
        get { RoomBgImage(rawValue: bgImage_) ?? .One }
        set { bgImage_ = newValue.rawValue }
    }
    
    var contactPayload: Contact.Payload? {
        members.filter{ $0.id != CurrentUser.id }.first
    }
}

enum RoomType {
    case single(Contact.Payload)
    case group([Contact.Payload])
}

enum RoomBgImage: Int16, CaseIterable, Identifiable {
    var id: Int16 { rawValue }
    case None, One, White, Blue, Brown
    
    var name: String { "chatBg\(rawValue)" }
    
    var image: some View {
        Group {
            if self != .None {
                Image(name)
                    .resizable()
                    .clipped()
            } else {
                //                    ChatBackground()
            }
        }
    }
}

enum RoomTheme: Int16, CaseIterable, Identifiable {
    var id: Int16 { rawValue }
    case Blue, Orange, Yellow, Green, Mint, Teal, Cyan, Red, Indigo, Purple, Pink, Brown, Gray
    
    var name: String {
        "\(self)"
    }
    
    var color: Color {
        switch self {
        case .Blue:
            return .blue
        case .Orange:
            return .orange
        case .Yellow:
            return .yellow
        case .Green:
            return .green
        case .Mint:
            return .mint
        case .Teal:
            return .teal
        case .Cyan:
            return .cyan
        case .Red:
            return .red
        case .Indigo:
            return .indigo
        case .Purple:
            return .purple
        case .Pink:
            return .pink
        case .Brown:
            return .brown
        case .Gray:
            return .gray
        }
    }
}
