//
//  ContactRepresentable.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 12/3/24.
//

import Foundation

protocol ContactRepresentable: AnyObject, Observable, Hashable, Identifiable, Sendable {
    associatedtype ContactItem = ContactRepresentable
    var id: String { get }
    var name: String { get }
    var phoneNumber: String { get }
    var photoUrl: String { get }
    var pushToken: String { get }
    init(id: String, name: String, phoneNumber: String, photoUrl: String, pushToken: String)
    static var currentUser: ContactItem { get }
}

extension ContactRepresentable {
    var isCurrentUser: Bool {
        id == Contact.currentUser.id
    }
    var isMsgUser: Bool {
        id != phoneNumber
    }
}
