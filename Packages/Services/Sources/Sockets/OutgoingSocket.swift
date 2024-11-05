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
import Database
public actor OutgoingSocket {
    
    private let queue = ActorQueue<OutgoingSocket>()
    private let swiftdataRepo = SwiftDatabase.shared.swiftdataRepo
    
    
    public func sent(_ msg: ChatMsg) {
        queue.enqueue { q in
            switch await self.swiftdataRepo.create(msg) {
            case .success(let msg):
                NotificationCenter.default.post(name: .msgNoti(for: msg.conID), object: AnyMsgData.newMsg(msg))
                do {
                    try await self.sendToRemote(msg)
                    var msg = msg
                    msg.deliveryStatus = .Sent
                    await self.updateToLocal(msg: msg)
                } catch {
                    var msg = msg
                    msg.deliveryStatus = .SendingFailed
                    await self.updateToLocal(msg: msg)
                }
            case .failure(let error):
                Log(error)
            }
        }
    }
    public func update(_ msg: ChatMsg) {
        queue.enqueue { q in
            try? await Task.sleep(seconds: 1)
            switch await self.swiftdataRepo.update(msg) {
            case .success(let msg):
                try? await self.updateToRemote(msg)
            case .failure(let error):
                Log(error)
            }
        }
    }
    private func updateToRemote(_ msg: ChatMsg) async throws {
        try await Task.sleep(seconds: [1, 2, 3].randomElement()!)
        await updateToLocal(msg: msg)
    }
    private func sendToRemote(_ msg: ChatMsg) async throws {
        try await Task.sleep(seconds: [1, 2, 3].randomElement()!)
    }
    
    private func updateToLocal(msg: ChatMsg) async {
        switch await swiftdataRepo.update(msg) {
        case .success(let newMsg):
            NotificationCenter.default.post(name: .msgNoti(for: newMsg.conID), object: AnyMsgData.updatedMsg(newMsg))
        case .failure(let error):
            Log(error)
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
