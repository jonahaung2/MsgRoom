//
//  MsgInteractionProvider.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 8/7/24.
//

import Foundation
import XUI
import AsyncQueue
import Models
@preconcurrency import Database
import Services

public struct ChatInteractionsProvider: ChatInteractionsConformation, Sendable {
    
    public let room: MsgRoom
    private var outgoingSocket = OutgoingSocket()
    private var swiftdataRepo = SwiftDatabase.shared.swiftdataRepo
    private let queue = FIFOQueue(priority: .userInitiated)
    public init(_ room: MsgRoom) {
        self.room = room
    }
    
    public func sendAction(_ action: MsgRoomAction) {
        switch action.item {
        case .sendMsg(let sendMsg):
            switch sendMsg {
            case .text(let string):
                let msg = ChatMsg(roomID: room.id, senderID: CurrentUser.current.id, msgKind: .Text, text: string)
                send(msg: msg)
            case .emoji(let string):
                let msg = ChatMsg(roomID: room.id, senderID: CurrentUser.current.id, msgKind: .Emoji, text: string)
                send(msg: msg)
            case .images(let urls):
                urls.forEach { each in
                    let msg = ChatMsg(roomID: room.id, senderID: CurrentUser.current.id, msgKind: .Image, text: each.absoluteString)
                    send(msg: msg)
                }
            case .video(_):
                break
            case .msg(let msg):
                send(msg: msg)
            }
        case .sendReaction(let sendReaction):
            switch sendReaction {
            case .react(_):
                break
            }
        case .update(let msg):
            queue.enqueue {
                switch await swiftdataRepo.update(msg) {
                case .success(let msg):
                    await outgoingSocket.sent(.updatedMsg(msg))
                case .failure(let error):
                    Log(error)
                }
            }
        }
    }
    private func send(msg: ChatMsg) {
        queue.enqueue {
            switch await swiftdataRepo.create(msg) {
            case .success(let msg):
                await outgoingSocket.sent(.newMsg(msg))
            case .failure(let error):
                Log(error)
            }
        }
    }
}
