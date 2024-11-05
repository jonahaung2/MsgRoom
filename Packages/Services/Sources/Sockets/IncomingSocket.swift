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
import Database

public actor IncomingSocket {
    
    private let queue = ActorQueue<IncomingSocket>()
    private let swiftdataRepo = SwiftDatabase.shared.swiftdataRepo
    
    public func receive(_ msg: ChatMsg) {
        queue.enqueue { socket in
            switch await self.swiftdataRepo.create(msg) {
            case .success(let msg):
                var msg = msg
                msg.deliveryStatus = .Received
                NotificationCenter.default.post(name: .msgNoti(for: msg.conID), object: AnyMsgData.newMsg(msg))
            case .failure(let error):
                Log(error)
            }
        }
    }
    public init() {
        queue.adoptExecutionContext(of: self)
    }
}
