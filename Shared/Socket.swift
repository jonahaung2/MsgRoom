//
//  Socket.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 7/4/24.
//

import UIKit
import XUI

class Socket {
    static let shared = Socket()
    private init() { }

    private let lock = RecursiveLock()
    
    func postMsg(_ noti: MsgNoti) {
        lock.sync {
            switch noti.type {
            case .New(let item):
                NotificationCenter.default.post(name: .msgNoti(for: item.conId), object: MsgNoti(type: .New(item: item)))
            case .Typing(let isTyping):
                break
            case .Update(let item):
                NotificationCenter.default.post(name: .msgNoti(for: item.conId), object: MsgNoti(type: .Update(item: item)))
            }
        }
    }
    func fireIncomingMsgNotification() {
        lock.sync {
            NotificationCenter.default.post(name: .MsgNoti, object: nil)
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
struct MsgNoti {
    enum NotiType {
        case New(item: any MsgKind)
        case Typing(isTyping: Bool)
        case Update(item: any MsgKind)
    }
    let type: NotiType
}

struct ContactNoti {
    enum NotiType {
        case New(item: Contact)
        case Update(id: String)
    }
    let type: NotiType
}

extension Notification.Name {
    static let MsgNoti = Notification.Name("Notification.Msgr.MsgDidReceive")
    static func msgNoti(for conID: String) -> Notification.Name {
        Notification.Name(conID)
    }
    static func contactNoti() -> Notification.Name {
        Notification.Name("contact")
    }
}

extension NotificationCenter.Publisher.Output {
    var msgNoti: MsgNoti? { self.object as? MsgNoti }
    var contactNoti: ContactNoti? { self.object as? ContactNoti }
}
