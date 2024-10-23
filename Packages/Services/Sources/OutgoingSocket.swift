//
//  OutgoingSocket.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 24/6/24.
//

import Foundation
import XUI
import AsyncQueue
import Models
@preconcurrency import Services

public actor OutgoingSocket {

    private let audioPlayer = AudioService()
    private let queue = ActorQueue<OutgoingSocket>()
    
    public func sent(_ data: AnyMsgData) {
        queue.enqueue { q in
            NotificationCenter.default.post(name: .msgNoti(for: data.conId), object: data)
            let path = (Bundle.main.resourcePath! as NSString).appendingPathComponent("rckit_outgoing.aiff")
            await self.audioPlayer.playSound(path)
        }
    }
    public init() {
        queue.adoptExecutionContext(of: self)
    }
}
public extension Notification.Name {
    private static let schema = "com.jonahaung.msgRoom"
    static func msgNoti(for conID: String) -> Notification.Name {
        Notification.Name(self.schema+"="+conID)
    }
}

public extension NotificationCenter.Publisher.Output {
    var anyMsgData: AnyMsgData? { self.object as? AnyMsgData }
}
