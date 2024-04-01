//
//  ContactRepresentable.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 12/3/24.
//

import Foundation

protocol Contactable: ObservableObject, Hashable, Identifiable, Equatable, Codable {
    var id: String { get }
    var name: String { get }
    var phoneNumber: String { get }
    var photoUrl: String { get }
    var pushToken: String { get }
    init(id: String, name: String, phoneNumber: String, photoUrl: String, pushToken: String)
}
extension Contactable {
    var isCurrentUser: Bool {
        id == CurrentUser.id
    }
    var isMsgUser: Bool {
        id != phoneNumber
    }
}
