//
//  OutgoingSocket.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 24/6/24.
//

import Foundation
import XUI

actor OutgoingSocket {
    
    private let queue: OperationQueue = {
        $0.name = "OutgoingSocket"
        $0.maxConcurrentOperationCount = 1
        $0.qualityOfService = .userInitiated
        return $0
    }(OperationQueue())
    private let audioPlayer = AudioPlayer()
    
    func sent(_ data: AnyMsgData) throws {
        queue.addOperation {
            NotificationCenter.default.post(name:.msgNoti(for: data.conId), object: data)
            let path = (Bundle.main.resourcePath! as NSString).appendingPathComponent("rckit_outgoing.aiff")
            self.audioPlayer.playSound(path)
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
