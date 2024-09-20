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
import Database
import Core

struct MsgInteractionProvider: MsgInteractions {
    
    let room: Room
    @Injected(\.outgoingSocket) private var outgoingSocket
    @Injected(\.swiftdataRepo) private var swiftdataRepo
    private let queue = FIFOQueue(priority: .userInitiated)
    init(_ room: Room) {
        self.room = room
    }
    
    func sendAction(_ action: MsgRoomAction) {
        switch action.item {
        case .sendMsg(let sendMsg):
            switch sendMsg {
            case .text(let string):
                let request = OpenAIClient.ChatRequest.init(content: string, temperature: 1)
                let msg = Msg(roomID: room.id, senderID: CurrentUser.current.id, msgKind: .Text, text: string)
                send(msg: msg)
            case .emoji(let string):
                let msg = Msg(roomID: room.id, senderID: CurrentUser.current.id, msgKind: .Emoji, text: string)
                send(msg: msg)
            case .images(let urls):
                urls.forEach { each in
                    let msg = Msg(roomID: room.id, senderID: CurrentUser.current.id, msgKind: .Image, text: each.absoluteString)
                    send(msg: msg)
                }
            case .video(_):
                break
            case .msg(let msg):
                send(msg: msg)
            }
        case .sendReaction(let sendReaction):
            switch sendReaction {
            case .react(let string):
                break
            }
        }
    }
    
    private func send(msg: Msg) {
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
