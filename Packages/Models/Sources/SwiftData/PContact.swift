//
//  ContactData.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 14/7/24.
//

import Foundation
import SwiftData

@Model
public final class PContact: IdentifiableByProxy {
    @Attribute(.unique) public var id: String
    public var name: String
    public var mobile: String
    public var photoURL: String
    public var pushToken: String
    public var groups: [PersistedRoom]?
    public var room: PersistedRoom?
    
    public init(id: String, name: String, phoneNumber mobile: String, photoUrl photoURL: String, pushToken: String) {
        self.id = id
        self.name = name
        self.mobile = mobile
        self.photoURL = photoURL
        self.pushToken = pushToken
    }
}

