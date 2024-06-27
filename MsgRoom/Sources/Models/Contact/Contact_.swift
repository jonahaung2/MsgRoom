//
//  ContactRepresentable.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 12/3/24.
//

import Foundation
import XUI

public protocol Contact_: Conformable {
    associatedtype Contact = Contact_
    var id: String { get set }
    var name: String { get set }
    var mobile: String { get set }
    var photoURL: String { get set }
    var pushToken: String { get set }
    init(id: String, name: String, phoneNumber: String, photoUrl: String, pushToken: String)
}
public extension Contact_ {
    var isCurrentUser: Bool {
        id == currentUserId
    }
    var isMsgUser: Bool {
        id != mobile
    }
}
