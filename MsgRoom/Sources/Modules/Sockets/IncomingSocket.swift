//
//  IncomingSocket.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 25/6/24.
//

import Foundation
import XUI

actor IncomingSocket {

    private let queue: OperationQueue = {
        $0.name = "IncomingSocket"
        $0.maxConcurrentOperationCount = 1
        $0.qualityOfService = .userInitiated
        return $0
    }(OperationQueue())
    private let audioPlayer = AudioPlayer()
    
    func receive(_ data: AnyMsgData) {
        queue.addOperation {
            NotificationCenter.default.post(name: .msgNoti(for: data.conId), object: data)
            let path = (Bundle.main.resourcePath! as NSString).appendingPathComponent("rckit_incoming.aiff")
            self.audioPlayer.playSound(path)
        }
    }
}
