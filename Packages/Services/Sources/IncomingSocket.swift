//
//  IncomingSocket.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 25/6/24.
//

import Foundation
import XUI
import AsyncQueue
import Models
@preconcurrency import Services

public actor IncomingSocket {

    private let queue = ActorQueue<IncomingSocket>()
    private let audioPlayer = AudioService()
    
    public func receive(_ data: AnyMsgData) {
        queue.enqueue { socket in
            NotificationCenter.default.post(name: .msgNoti(for: data.conId), object: data)
            let path = (Bundle.main.resourcePath! as NSString).appendingPathComponent("rckit_incoming.aiff")
            await self.audioPlayer.playSound(path)
        }
    }
    public init() {
        queue.adoptExecutionContext(of: self)
    }
}
