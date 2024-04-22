//
//  GroupContainer.swift
//  Msgr
//
//  Created by Aung Ko Min on 6/11/22.
//

import Foundation

final class GroupContainer: ObservableObject {

    static let appGroupId = "group.com.aungkomin.Msgr.v3"
    static let appIsExtension = Bundle.main.bundlePath.hasSuffix(".appex")
    private static let container = UserDefaults(suiteName: appGroupId)!

    static var pushToken: String? {
        get {
            return container.string(forKey: "pushToken")
        }
        set {
            container.set(newValue, forKey: "pushToken")
        }
    }
//    static var msgPayloads: [Msg.Payload] {
//        get {
//            if let objects = container.value(forKey: "pushed_objects") as? Data {
//                let decoder = JSONDecoder()
//                if let objectsDecoded = try? decoder.decode(Array.self, from: objects) as [Msg.Payload] {
//                    return objectsDecoded
//                }
//            }
//            return []
//        }
//        set {
//            let encoder = JSONEncoder()
//            if let encoded = try? encoder.encode(newValue){
//                container.set(encoded, forKey: "pushed_objects")
//                container.synchronize()
//            }
//        }
//
//    }
}
