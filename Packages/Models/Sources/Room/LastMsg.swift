//
//  LastMsg.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 1/7/24.
//

import Foundation

public struct LastMsg: Conformable, Codable {
    
    public let id: String
    public let text: String
    public let senderName: String
    public let senderId: String
    public let senderURL: String?
    public let date: Date
    
    public init(id: String, text: String, senderName: String, senderId: String, senderURL: String?, date: Date) {
        self.id = id
        self.text = text
        self.senderName = senderName
        self.senderId = senderId
        self.senderURL = senderURL
        self.date = date
    }
}
public extension LastMsg {
    init(msg: Msg, sender: Contact?) {
        self.init(
            id: msg.id,
            text: msg.text,
            senderName: sender?.name ?? "Me",
            senderId: sender?.id ?? CurrentUser.current.id,
            senderURL: sender?.photoURL,
            date: msg.date
        )
    }
}
