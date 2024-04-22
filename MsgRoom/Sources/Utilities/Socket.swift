//
//  Socket.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 7/4/24.
//

import UIKit
import XUI
import MsgrCore

class Socket {
    static let shared = Socket()
    private init() { }
    
    private let lock = RecursiveLock()
    private let notificationCenter = NotificationCenter.default
    let queue = OperationQueue()
    
    func postOutgoing(_ data: OutgoinData) {
        lock.sync {
            switch data {
            case .newMsg(let msg, let to):
                // Do the posting process
                switch to.type {
                case .single(let contactRepresentable):
                    queue.addOperation(PushNotiSendOperation(msg, contact: contactRepresentable))
                case .group(let array):
                    array.forEach { each in
                        queue.addOperation(PushNotiSendOperation(msg, contact: each))
                    }
                }
            case .updateMsg(let msg, let to):
                break
            case .typingStatus(let isTyping):
                break
            }
        }
    }
    
    func receiveIncoming(_ data: IncomingData) {
        lock.sync {
            switch data {
            case .newMsg(let msg):
                notificationCenter.post(name: .init(msg.conId), object: data)
            case .updateMsg(let msg):
                notificationCenter.post(name: .init(msg.conId), object: data)
            case .typing(let conID, let uids):
                notificationCenter.post(name: .init(conID), object: data)
            }
        }
    }
    func fireAlertMessage(title: String, body: String) {
        lock.sync {
            let content = UNMutableNotificationContent()
            content.title = title
            content.body = body
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1.0, repeats: false)
            let request = UNNotificationRequest(identifier: "local_notification", content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request) { (error) in
                if let error {
                    print(error)
                }
            }
        }
    }
}

extension NotificationCenter.Publisher.Output {
    var incomingData: IncomingData? {
        self.object as? IncomingData
    }
}
