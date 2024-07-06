//
//  ConRepresentable.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 12/3/24.
//

import SwiftUI
import XUI
import SwiftData

public protocol RoomRepresentable<C>: Conformable, AnyObject {
    
    associatedtype C = ContactRepresentable
    
    var id: String { get }
    var name: String { get set }
    var type: RoomType { get }
    var createdDate: Date { get }
    var photoURL: String? { get set }
    var contacts: [C] { get set }
    var lastMsg: LastMsg? { get set }
    
    func msgs<T>() -> [T] where T: MsgRepresentable
    static func create(id: String, date: Date, name: String, photoUrl: String, type: RoomType) async throws -> (any RoomRepresentable)?
    
    func safeObject() async -> Self
}
