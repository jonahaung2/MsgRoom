//
//  LastMsg.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 1/7/24.
//

import Foundation
import XUI

struct LastMsg: Conformable, Codable {
    
    let id: String
    let text: String
    let senderName: String
    let senderId: String
    let senderURL: String?
    let date: Date
    
    init(id: String, text: String, senderName: String, senderId: String, senderURL: String?, date: Date) {
        self.id = id
        self.text = text
        self.senderName = senderName
        self.senderId = senderId
        self.senderURL = senderURL
        self.date = date
    }
}
extension LastMsg {
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
