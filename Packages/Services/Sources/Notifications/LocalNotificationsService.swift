//
//  LocalNotificationService.swift
//  Services
//
//  Created by Aung Ko Min on 28/10/24.
//

import Foundation
import UserNotificationsUI

public enum LocalNotificationsService {
    public static func sendAlert(
        id: String = UUID().uuidString,
        title: String?,
        subtitle: String = "",
        body: String = ""
    ) {
        self.post(
            id: id,
            title: title ?? "",
            subtitle: subtitle,
            body: body,
            sound: .none
        )
    }
    public static
    func post(
        id: String,
        title: String,
        subtitle: String,
        body: String,
        badge: NSNumber? = nil,
        sound: UNNotificationSound? = .default,
        launchImageName: String? = nil,
        userInfo: [AnyHashable: Any] = [:],
        attachments: [UNNotificationAttachment] = [],
        categoryIdentifier: String? = nil,
        threadIdentifier: String? = nil,
        targetContentIdentifier: String? = nil,
        interruptionLevel: UNNotificationInterruptionLevel? = nil,
        relevanceScore: Double? = nil,
        options: UNAuthorizationOptions = [],
        trigger: (() -> UNNotificationTrigger)? = nil
    ) {
        _post(
            id: id,
            title: title,
            subtitle: subtitle,
            body: body,
            badge: badge,
            sound: sound,
            launchImageName: launchImageName,
            userInfo: userInfo,
            attachments: attachments,
            summaryArgument: nil,
            summaryArgumentCount: nil,
            categoryIdentifier: categoryIdentifier,
            threadIdentifier: threadIdentifier,
            targetContentIdentifier: targetContentIdentifier,
            interruptionLevel: interruptionLevel,
            relevanceScore: relevanceScore,
            options: options, trigger: trigger
        )
    }
    public static
    func post(
        id: String,
        title: String,
        subtitle: String,
        body: String,
        badge: NSNumber? = nil,
        sound: UNNotificationSound? = .default,
        launchImageName: String? = nil,
        userInfo: [AnyHashable: Any] = [:],
        attachments: [UNNotificationAttachment] = [],
        summaryArgument: String? = nil,
        summaryArgumentCount: Int? = nil,
        categoryIdentifier: String? = nil,
        threadIdentifier: String? = nil,
        targetContentIdentifier: String? = nil,
        interruptionLevel: UNNotificationInterruptionLevel? = nil,
        relevanceScore: Double? = nil,
        options: UNAuthorizationOptions = [],
        trigger: (() -> UNNotificationTrigger)? = nil
    ) {
        _post(
            id: id,
            title: title,
            subtitle: subtitle,
            body: body,
            badge: badge,
            sound: sound,
            launchImageName: launchImageName,
            userInfo: userInfo,
            attachments: attachments,
            summaryArgument: nil,
            summaryArgumentCount: nil,
            categoryIdentifier: categoryIdentifier,
            threadIdentifier: threadIdentifier,
            targetContentIdentifier: targetContentIdentifier,
            interruptionLevel: interruptionLevel,
            relevanceScore: relevanceScore,
            options: options, trigger: trigger
        )
    }
    
    private static func _post(
        id: String,
        title: String,
        subtitle: String,
        body: String,
        badge: NSNumber? = nil,
        sound: UNNotificationSound? = .default,
        launchImageName: String? = nil,
        userInfo: [AnyHashable: Any] = [:],
        attachments: [UNNotificationAttachment] = [],
        summaryArgument: String? = nil,
        summaryArgumentCount: Int? = nil,
        categoryIdentifier: String? = nil,
        threadIdentifier: String? = nil,
        targetContentIdentifier: String? = nil,
        interruptionLevel: UNNotificationInterruptionLevel? = nil,
        relevanceScore: Double? = nil,
        options: UNAuthorizationOptions = [],
        trigger: (() -> UNNotificationTrigger)? = nil
    ) {
        var options = options
        
        if badge != nil { options.insert(.badge) }
        if sound != nil { options.insert(.sound) }
        if sound == .defaultCritical { options.insert(.criticalAlert) }
        options.insert(.alert)
        
        UNUserNotificationCenter.current().requestAuthorization(options: options) { success, error in
            if success {
                print("Authorization Granted")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = subtitle
        content.body = body
        content.badge = badge
        content.sound = sound
        
        if let launchImageName = launchImageName {
            content.launchImageName = launchImageName
        }
        
        content.userInfo = userInfo
        content.attachments = attachments
        
        if let categoryIdentifier = categoryIdentifier {
            content.categoryIdentifier = categoryIdentifier
        }
        
        if let threadIdentifier = threadIdentifier {
            content.threadIdentifier = threadIdentifier
        }
        
        content.targetContentIdentifier = targetContentIdentifier
        
        if let interruptionLevel = interruptionLevel {
            content.interruptionLevel = interruptionLevel
        }
        
        if let relevanceScore = relevanceScore {
            content.relevanceScore = relevanceScore
        }
        
        var computedTrigger: UNNotificationTrigger?
        
        if let trigger = trigger {
            computedTrigger = trigger()
        }
        
        let request = UNNotificationRequest(
            identifier: id,
            content: content,
            trigger: computedTrigger
        )
        UNUserNotificationCenter.current().add(request)
    }
}
