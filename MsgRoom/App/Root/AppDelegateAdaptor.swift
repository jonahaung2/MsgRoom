//
//  AppDelegateAdaptor.swift
//  Myanmar Song Book
//
//  Created by Aung Ko Min on 9/5/22.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseMessaging
import XUI

class AppDelegateAdaptor: NSObject, UIApplicationDelegate {
    
    let pushNotificationManager = PushNotificationManager.shared
    //    let authenticator = Authenticator.shared
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication .LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        pushNotificationManager.registerForPushNotifications()
        //        authenticator.observe()
        return true
    }
    
    //    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    //        let hexString = deviceToken.hexString
    //        Log(hexString)
    //        Auth.auth().setAPNSToken(deviceToken, type: .sandbox)
    //        Messaging.messaging().apnsToken = deviceToken
    //    }
    //
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) async -> UIBackgroundFetchResult {
        if Auth.auth().canHandleNotification(userInfo) {
            return .newData
        } else {
            Messaging.messaging().appDidReceiveMessage(userInfo)
            return .newData
        }
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        //        CoreDataStack.shared.save()
    }
    
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        if Auth.auth().canHandle(url) {
            return true
        }
        return false
    }
}
extension Data {
    var hexString: String {
        let hexString = map { String(format: "%02.2hhx", $0) }.joined()
        return hexString
    }
}
