//
//  LocalNotifications.swift
//  Msgr
//
//  Created by Aung Ko Min on 6/11/22.
//

import Foundation
import UIKit

class LocalNotifications {

    static func postMsg(payload: any Msgable) {
        NotificationCenter.default.post(name: .msgNoti(for: payload.conId), object: MsgNoti(type: .New(item: payload)))
    }
    static func postContact(payload: Contact.Payload) {
        NotificationCenter.default.post(name: .contactNoti(), object: ContactNoti(type: .New(item: payload)))
    }

    static func fireIncomingMsgNotification() {
        NotificationCenter.default.post(name: .MsgNoti, object: nil)
    }
    static func fireAlertMessage(title: String, body: String) {
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


struct MsgNoti {
    enum NotiType {
        case New(item: any Msgable)
        case Typing(isTyping: Bool)
        case Update(id: String)
    }
    let type: NotiType
}

struct ContactNoti {
    enum NotiType {
        case New(item: Contact.Payload)
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
