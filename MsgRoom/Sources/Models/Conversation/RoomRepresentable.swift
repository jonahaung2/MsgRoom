//
//  ConRepresentable.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 12/3/24.
//

import SwiftUI
import XUI
import SwiftData

protocol RoomRepresentable: Conformable, AnyObject {
    var id: String { get }
    var name: String { get set }
    var type: RoomType { get }
    var createdDate: Date { get }
    var photoURL: String? { get set }
    var contacts: [any ContactRepresentable] { get set }
    
    func msgs<T>() -> [T] where T: MsgRepresentable
    static func create(id: String, date: Date, name: String, photoUrl: String, type: RoomType) async throws -> (any RoomRepresentable)?
}

extension RoomRepresentable {
    func bubbleColor(for msg: any MsgRepresentable) -> Color {
        msg.recieptType == .Send ?
        Color.accentColor
        :
        Color(uiColor: .tertiarySystemFill).opacity(1)
    }
}
