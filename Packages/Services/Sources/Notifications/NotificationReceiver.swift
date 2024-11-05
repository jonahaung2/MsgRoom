//
//  NotificationReceiver.swift
//  Services
//
//  Created by Aung Ko Min on 29/10/24.
//

import Foundation
import UserNotifications

public class NotificationReceiver: NSObject {
    public override init() {
        super.init()
    }
}

extension NotificationReceiver: UNUserNotificationCenterDelegate {
    
    public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        return [.banner, .sound, .badge, .list]
    }
    public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        if response.actionIdentifier == UNNotificationDefaultActionIdentifier {
            print(response)
        }
    }
    public func userNotificationCenter(_ center: UNUserNotificationCenter, openSettingsFor notification: UNNotification?) {
        print(notification)
    }
}
