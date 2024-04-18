//
//  PushNotiSendOperation.swift
//  Msgr
//
//  Created by Aung Ko Min on 28/10/22.
//

import SwiftUI

final class PushNotiSendOperation<Msg: MsgKind, Con: ConKind>: Operation {

    enum OperationError: Error {
        case cancelled, serialization, noData
    }

    enum API {
        static var apnKey: String { "AAAACFxx6VY:APA91bHjtP9ccXft7qzpMhTE6Lso9YheenvG2z9kZ7XVfPJB0gOrAPOuEJE0iKuJNNJt8HSi8YBHA4sYwHjvqvNiEh1o0NvSN-lUzlDO4pwPWBXAbmPhqI6XI1wJRNZYtbJdYHEE2KUy" }
        static var url: URL { URL(string: "https://fcm.googleapis.com/fcm/send")! }
    }
    private let payload: Msg
    private let contact: Contact

    var result: Result<Bool, Error>?
    private var currentTask: URLSessionDataTask?
    private var downloading = false
    override var isAsynchronous: Bool { true }
    override var isExecuting: Bool { downloading }
    override var isFinished: Bool { result != nil }

    init(_ msg: Msg, contact: Contact) {
        self.payload = msg
        self.contact = contact
    }

    override func cancel() {
        super.cancel()
        if let currentDownloadTask = currentTask {
            currentDownloadTask.cancel()
        }
    }
    private func finish(result: Result<Bool, Error>) {
        guard downloading else { return }

        willChangeValue(forKey: #keyPath(isExecuting))
        willChangeValue(forKey: #keyPath(isFinished))

        self.result = result
        downloading = false
        currentTask = nil

        switch result {
        case .success(let success):
//            Msg.msg(for: payload.id)?.deliveryStatus = success ? .Sent : .SendingFailed
            Audio.playMessageOutgoing()
        case .failure(let failure):
            print(failure)
//            Msg.msg(for: payload.id)?.deliveryStatus = .SendingFailed
        }
        didChangeValue(forKey: #keyPath(isFinished))
        didChangeValue(forKey: #keyPath(isExecuting))
    }

    override func start() {
        willChangeValue(forKey: #keyPath(isExecuting))
        downloading = true
        didChangeValue(forKey: #keyPath(isExecuting))
        let token = contact.pushToken
        guard !isCancelled else {
            finish(result: .failure(OperationError.cancelled))
            return
        }

        var notification = [AnyHashable: Any]()
        notification["title"] = contact.name
        notification["subtitle"] = contact.phoneNumber
        notification["body"] = payload.text
        notification["mutable_content"] = true
        notification["sound"] = "default"
        notification["content_available"] = true
        notification["badge"] = 1

        var data = [AnyHashable: Any]()
//        data["msg"] = payload.dictionary

        let paramString = [
            "to" : token,
            "notification" : notification,
            "data" : data
        ] as [AnyHashable : Any]
        
        do {
            let body = try JSONSerialization.data(withJSONObject: paramString, options: .prettyPrinted)

            let request = NSMutableURLRequest(url: API.url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("key=\(API.apnKey)", forHTTPHeaderField: "Authorization")
            request.httpBody = body

            let urlRequest = request as URLRequest
            currentTask = URLSession.shared.dataTask(with: urlRequest) { data, _, error in
                guard !self.isCancelled else {
                    self.finish(result: .failure(OperationError.cancelled))
                    return
                }
                if let error {
                    self.finish(result: .failure(error))
                    return
                }
                guard let data else {
                    self.finish(result: .failure(OperationError.noData))
                    return
                }
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? NSDictionary
                    guard let json else {
                        self.finish(result: .failure(OperationError.serialization))
                        return
                    }
                    if let success = json.value(forKey: "success") as? Int {
                        let successful = success == 1
                        self.finish(result: .success(successful))
                    } else {
                        self.finish(result: .failure(OperationError.serialization))
                    }
                } catch {
                    self.finish(result: .failure(error))
                }
            }
            currentTask?.resume()

        } catch {
            print(error)
            finish(result: .failure(OperationError.serialization))
        }
    }
}


//final class PushNotiSendOperation: Operation {
//
//    enum API {
//        static let apnKey = "AAAACFxx6VY:APA91bHjtP9ccXft7qzpMhTE6Lso9YheenvG2z9kZ7XVfPJB0gOrAPOuEJE0iKuJNNJt8HSi8YBHA4sYwHjvqvNiEh1o0NvSN-lUzlDO4pwPWBXAbmPhqI6XI1wJRNZYtbJdYHEE2KUy"
//        static let url = URL(string: "https://fcm.googleapis.com/fcm/send")!
//    }
//
//    private let msg_: MsgPayload
//    private let token: String
//
//    init(_ msg_: MsgPayload, token: String) {
//        self.msg_ = msg_
//        self.token = token
//    }
//
//    override func main() {
//        if isCancelled { return }
//        let paramString = [
//            "to" : token,
//            "notification" : [
//                "title" : msg_.senderId,
//                "subtitle": msg_.conId,
//                "body" : msg_.text,
//                "mutable_content": true,
//                "sound": "default",
//                "content_available": true,
//                "badge": 1
//            ],
//            "data" : [
//                "msg": msg_.data()
//            ]
//        ] as [String : Any]
//
//        guard let body = try?
//                JSONSerialization.data(withJSONObject: paramString, options: .prettyPrinted)
//        else { return }
//
//        let request = NSMutableURLRequest(url: API.url)
//        request.httpMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.setValue("key=\(API.apnKey)", forHTTPHeaderField: "Authorization")
//        request.httpBody = body
//
//        let urlRequest = request as URLRequest
//        let session = URLSession.shared.dataTask(with: urlRequest) { data, _, error in
//            if let error {
//                print(error)
//                return
//            }
//            guard let data else { return }
//            do {
//                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? NSDictionary
//                guard
//                    let json
//                else { return }
//                if let success = json.value(forKey: "success") as? Int {
//                    let successful = success == 1
//                    print(successful)
//                }
//            } catch {
//                print("Something went wrong")
//            }
//        }
//        session.resume()
//    }
//}

