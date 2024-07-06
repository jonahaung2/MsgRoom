//
//  ContactRepresentable.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 12/3/24.
//

import Foundation
import XUI

public protocol ContactRepresentable<Room>: Conformable, AnyObject {
    
    associatedtype Room = any RoomRepresentable
    
    var id: String { get }
    var name: String { get set }
    var mobile: String { get set }
    var photoURL: String { get set }
    var pushToken: String { get set }
    var room: Room? { get set }
    init(
        id: String,
        name: String,
        phoneNumber: String,
        photoUrl: String,
        pushToken: String)
    
    @MainActor
    static func fetch(for id: String) -> Self?
}
