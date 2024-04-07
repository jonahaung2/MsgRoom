//
//  NotificationService.swift
//  MsgrNotificatrionService
//
//  Created by Aung Ko Min on 6/4/24.
//

import UserNotifications

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?
   

    override init() {
        super.init()
//        FirebaseApp.configure()
    }

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {

//        self.contentHandler = contentHandler
//        bestAttemptContent = request.content.mutableCopy() as? UNMutableNotificationContent
//        guard let bestAttemptContent else { return }
//
//        if let msgPL = Msg.Payload.msgPayload(from: bestAttemptContent.userInfo) {
//            let senderId = msgPL.senderId
//            let conId = msgPL.conId
//
//            if contactHasSaved(for: senderId) {
//                if conHasSaved(for: conId) {
//                    saveMsgAndReturn()
//                } else {
//                    // Download Con
//                }
//            } else {
//                fetchContact(id: senderId) {[weak self] contactPL in
//                    guard let self = self else { return }
//                    if let contactPL {
//                        self.coreStorage.insert(payload: contactPL)
//                    }
//                    if self.conHasSaved(for: conId) {
//                        saveMsgAndReturn()
//                    } else {
//                        // Download Con
//                    }
//                }
//            }
//
//            func saveMsgAndReturn() {
//                coreStorage.insert(payload: msgPL, informSavedNotification: false)
//                contentHandler(bestAttemptContent)
//            }
//        } else {
////            self.downloadImageFrom(url: "https://media-exp1.licdn.com/dms/image/C5603AQEmuML1GXI9DQ/profile-displayphoto-shrink_800_800/0/1630504470059?e=1672272000&v=beta&t=lAsZRcQIW79CdEN3Fps8WTRGuotjMBN8c1PSttvOsWo") { attachment in
////                if let attachment = attachment {
////                    bestAttemptContent.attachments = [attachment]
////                }
////                contentHandler(bestAttemptContent)
////            }
//        }
    }

    override func serviceExtensionTimeWillExpire() {
//        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
//            if let msgPayload = Msg.Payload.msgPayload(from: bestAttemptContent.userInfo) {
//                bestAttemptContent.categoryIdentifier = msgPayload.conId
//                coreStorage.insert(payload: msgPayload, informSavedNotification: false)
//            }
//            contentHandler(bestAttemptContent)
//        }
    }

}

extension NotificationService {

//    private func fetchContact(id: String, completion: @escaping (Contact.Payload?) -> Void) {
////        Firestore.firestore().collection("users").document(id).getDocument { snap, _ in
////            let payload = try? snap?.data(as: Contact.Payload.self)
////            completion(payload)
////        }
//    }

    private func contactHasSaved(for id: String) -> Bool {
        return true
//        let context = CoreDataStack.shared.viewContext
//        let request = Contact.fetchRequest()
//        request.resultType = .countResultType
//        request.fetchLimit = 1
//        request.predicate = .init(format: "id == %@", id)
//        do {
//            let count = try context.count(for: request)
//            return count > 0
//        } catch {
//            print(error.localizedDescription)
//            return false
//        }
    }

    private func conHasSaved(for id: String) -> Bool {
        true
//        let context = CoreDataStack.shared.viewContext
//        let request = Con.fetchRequest()
//        request.resultType = .countResultType
//        request.fetchLimit = 1
//        request.predicate = .init(format: "id == %@", id)
//        do {
//            let count = try context.count(for: request)
//            return count > 0
//        } catch {
//            print(error.localizedDescription)
//            return false
//        }
    }
}

extension NotificationService {
    private func downloadImageFrom(url: String, handler: @escaping (UNNotificationAttachment?) -> Void) {
        let task = URLSession.shared.downloadTask(with: URL(string: url)!) { downloadedUrl, response, error in
            guard let downloadedUrl = downloadedUrl else {
                handler(nil)
                return
            }
            var urlPath = URL(fileURLWithPath: NSTemporaryDirectory())

            let uniqueUrlEnding = ProcessInfo.processInfo.globallyUniqueString + ".jpg"
            urlPath = urlPath.appendingPathComponent(uniqueUrlEnding)
            try? FileManager.default.moveItem(at: downloadedUrl, to: urlPath)
            do {
                let attachment = try UNNotificationAttachment(identifier: "picture", url: urlPath, options: nil)
                handler(attachment)
            } catch {
                print("attachment error")
                handler(nil)
            }
        }
        task.resume()
    }
}
