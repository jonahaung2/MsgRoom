//
//  CurrentUser.swift
//
//
//  Created by Aung Ko Min on 2/7/24.
//

import Foundation
import XUI

final class CurrentUser: Conformable, @unchecked Sendable {
    var room: Room?
    var id: String
    var name: String
    var mobile: String
    var photoURL: String
    var pushToken: String
    
    required init(id: String, name: String, phoneNumber: String, photoUrl: String, pushToken: String) {
        self.id = id
        self.name = name
        self.mobile = phoneNumber
        self.photoURL = photoUrl
        self.pushToken = pushToken
    }
    
    static func fetch(for id: String) -> Self? {
        nil
    }
    
    func hash(into hasher: inout Hasher) {
        id.hash(into: &hasher)
    }
    static func == (lhs: CurrentUser, rhs: CurrentUser) -> Bool {
        lhs.id == rhs.id
    }
    
    @Atomic
    public
    static var current = CurrentUser(id: "aungkomin", name: "Aung Ko Min", phoneNumber: "+6588585229", photoUrl: "https://scontent.fsin14-1.fna.fbcdn.net/v/t39.30808-6/434087047_10160183075747817_4706621247577569930_n.jpg?_nc_cat=110&ccb=1-7&_nc_sid=6ee11a&_nc_ohc=ixXT2bGgHZcQ7kNvgEVpfNG&_nc_ht=scontent.fsin14-1.fna&oh=00_AYDk26Ww6lXndekCIzzLzwbqAhh6iyZuzrBiUTaVXuS2OQ&oe=6688B4AC", pushToken: "push")
}

extension CurrentUser {
    var isCurrentUser: Bool {
        id == CurrentUser.current.id
    }
    var isMsgUser: Bool {
        id != mobile
    }
}
