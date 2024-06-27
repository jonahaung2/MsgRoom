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
            NotificationCenter.default.post(name:.msgNoti(for: data.conId), object: data)
            Audio.playMessageOutgoing()
        }
    }
}
extension Notification.Name {
    private static let schema = "com.jonahaung.msgRoom"
    static func msgNoti(for conID: String) -> Notification.Name {
        Notification.Name(self.schema+"="+conID)
    }
}

extension NotificationCenter.Publisher.Output {
    var anyMsgData: AnyMsgData? { self.object as? AnyMsgData }
}
