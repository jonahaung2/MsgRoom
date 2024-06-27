//
//  ContactRepresentable.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 12/3/24.
//

import Foundation
import XUI

public protocol ContactRepresentable: Conformable {
    associatedtype ContactItem = ContactRepresentable
    var id: String { get set }
    var name: String { get set }
    var phoneNumber: String { get set }
    var photoUrl: String { get set }
    var pushToken: String { get set }
    init(id: String, name: String, phoneNumber: String, photoUrl: String, pushToken: String)
    static var currentUser: ContactItem { get }
}
public extension ContactRepresentable {
    var isCurrentUser: Bool {
        id == Contact.currentUser.id
    }
    var isMsgUser: Bool {
        id != phoneNumber
    }
}
