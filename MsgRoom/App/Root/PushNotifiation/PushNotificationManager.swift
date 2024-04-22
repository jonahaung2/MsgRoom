//
//  PushNotificationManager.swift
//  FirebaseStarterKit
//
//  Created by Florian Marcu on 1/28/19.
//  Copyright © 2019 Instamobile. All rights reserved.
//

import UIKit
import FirebaseMessaging
import UserNotifications
import XUI

class PushNotificationManager: NSObject, ObservableObject {
    
    static let shared = PushNotificationManager()
    var currentConId: String?
    
    private override init() {
        super.init()
    }
    
    @MainActor
    func registerForPushNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler: { _, _ in })
        UIApplication.shared.registerForRemoteNotifications()
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
    }
}


extension PushNotificationManager: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        Log(fcmToken)
        GroupContainer.pushToken = fcmToken
    }
}

extension PushNotificationManager: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        completionHandler([.banner, .badge, .list])
        //        if let msgPayload = Msg.Payload.msgPayload(from: userInfo) {
        //            Audio.playMessageIncoming()
        //            if let currentConId {
        //                if currentConId == msgPayload.conId {
        //                    LocalNotifications.postMsg(payload: msgPayload)
        //                }
        //            } else {
        //                LocalNotifications.fireIncomingMsgNotification()
        //            }
        //            completionHandler(msgPayload.conId == self.currentConId ? [] : [.banner, .badge, .list])
        //        } else {
        //            completionHandler([.banner, .badge, .list])
        //        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        completionHandler()
        //        if let msgPayload = Msg.Payload.msgPayload(from: userInfo) {
        //            if let currentConId {
        //                if currentConId == msgPayload.conId {
        //                    LocalNotifications.postMsg(payload: msgPayload)
        //                }
        //            } else {
        //                LocalNotifications.fireIncomingMsgNotification()
        //            }
        //            ViewRouter.shared.routes.append(.chatView(conId: msgPayload.conId))
        //            completionHandler()
        //        } else {
        //            completionHandler()
        //        }
    }
    //    func unObserveMsgs() {
    //        firestoreListener?.remove()
    //        firestoreListener = nil
    //    }
    //    func observeMsgs() {
    //        unObserveMsgs()
    //        let reference = Firestore.firestore().collection("msgs")
    //        let query = reference.whereField("recipientId", isEqualTo: CurrentUser.id)
    //        firestoreListener = query.addSnapshotListener { snapshot, error in
    //            if let error {
    //                print(error)
    //                return
    //            }
    //            if let snapshot, !snapshot.isEmpty {
    //                let documents = snapshot.documents.compactMap{ $0.data() as NSDictionary }
    //                let msgs = documents.compactMap(MsgPayload.init)
    //                self.store.insert(payloads: msgs) {
    //                    snapshot.documents.forEach { each in
    //                        each.reference.delete()
    //                    }
    //                }
    //            }
    //        }
    //    }
    //
    //    func fetchNewMsgs() {
    //        let reference = Firestore.firestore().collection("msgs")
    //        let query = reference.whereField("recipientId", isEqualTo: CurrentUser.id)
    //        query.getDocuments { snapshot, error in
    //            if let error {
    //                print(error)
    //                return
    //            }
    //            if let snapshot, !snapshot.isEmpty {
    //                let documents = snapshot.documents
    //                documents.forEach { document in
    //                    let dic = document.data() as NSDictionary
    //                    if let payload = MsgPayload(dic: dic) {
    //                        self.store.insert(payload: payload)
    //                    }
    //                    document.reference.delete()
    //                }
    //            }
    //        }
    //    }
}

