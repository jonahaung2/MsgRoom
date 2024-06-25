//
//  OutgoingSocket.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 24/6/24.
//

import Foundation
import XUI

actor OutgoingSocket {
    
    private let lock = RecursiveLock()
    
    func sent(_ data: AnyMsgData) throws {
        lock.sync {
            NotificationCenter.default.post(name: .init(data.conId), object: data)
            Audio.playMessageOutgoing()
        }
    }
}
