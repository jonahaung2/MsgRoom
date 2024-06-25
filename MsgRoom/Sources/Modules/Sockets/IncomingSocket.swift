//
//  IncomingSocket.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 25/6/24.
//

import Foundation
import XUI

actor IncomingSocket {
    
    private let lock = RecursiveLock()
    
    func receive(_ data: AnyMsgData) {
        lock.sync {
            NotificationCenter.default.post(name: .init(data.conId), object: data)
            Audio.playMessageIncoming()
        }
    }
}
