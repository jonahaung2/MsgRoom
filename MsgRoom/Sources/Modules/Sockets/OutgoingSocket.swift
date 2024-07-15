//
//  OutgoingSocket.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 24/6/24.
//

import Foundation
import XUI
import AsyncQueue

actor OutgoingSocket {

    private let audioPlayer = AudioPlayer()
    private let queue = ActorQueue<OutgoingSocket>()
    
    func sent(_ data: AnyMsgData) {
        queue.enqueue { q in
            NotificationCenter.default.post(name: .msgNoti(for: data.conId), object: data)
            let path = (Bundle.main.resourcePath! as NSString).appendingPathComponent("rckit_outgoing.aiff")
            self.audioPlayer.playSound(path)
        }
    }
    init() {
        queue.adoptExecutionContext(of: self)
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
