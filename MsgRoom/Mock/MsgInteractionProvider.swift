//
//  MsgInteractionProvider.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 8/7/24.
//

import Foundation
import XUI
import AsyncQueue

struct MsgInteractionProvider: MsgInteractionProviding {
    
    let room: any RoomRepresentable
    private let queue = FIFOQueue(priority: .background)
    @Injected(\.outgoingSocket) private var outgoingSocket
    @Injected(\.coredataRepo) private var coredataRepo
    
    init(_ room: any RoomRepresentable) {
        self.room = room
    }
    
    nonisolated
    func sendAction(_ action: MsgRoomAction) {
        switch action.item {
        case .sendMsg(let sendMsg):
            switch sendMsg {
            case .text(let string):
                queue.enqueue {
                    let msg = Msg(roomID: room.id, senderID: CurrentUser.current.id, msgKind: .Text, text: string)
                    await send(msg: msg)
                }
            case .emoji(let string):
                queue.enqueue {
                    let msg = Msg(roomID: room.id, senderID: CurrentUser.current.id, msgKind: .Emoji, text: string)
                    await send(msg: msg)
                }
            case .images(let urls):
                urls.forEach { each in
                    queue.enqueue {
                        let msg = Msg(roomID: room.id, senderID: CurrentUser.current.id, msgKind: .Image, text: each.absoluteString)
                        await send(msg: msg)
                    }
                }
            case .video(_):
                break
            }
        case .sendReaction(let sendReaction):
            switch sendReaction {
            case .react(let string):
                print(string)
            }
        }
    }
    
    func send(msg: Msg) async {
        do {
            switch await coredataRepo.create(msg) {
            case .success(let msg):
                try await outgoingSocket.sent(.newMsg(msg))
            case .failure(let error):
                Log(error)
            }
        } catch {
            Log(error)
        }
    }
   
    
    init(_ room: Room) {
        self.room = room
    }
}
