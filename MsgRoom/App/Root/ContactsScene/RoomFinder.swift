//
//  RoomFinder.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 3/7/24.
//

import Foundation
import SwiftData
import XUI

struct RoomFinder<Msg: MsgRepresentable, Room: RoomRepresentable & PersistentModel, Contact: ContactRepresentable> {
    
    @Injected(\.swiftDatabase) private var swiftDatabase
    
    @MainActor
    func getOrCreateRoomFor(for contact: Contact, context: ModelContext) async throws -> Room {
        let id = getRoomId(for: CurrentUser.current.id, two: contact.id)
        let room = try await Room.create(id: id, date: .now, name: contact.name, photoUrl: contact.photoURL, type: .single)
        try context.save()
        contact.room = room as? Contact.Room
        return room as! Room
    }
    
    private func getRoomId(for one: String, two: String) -> String  {
        one > two ? two+one : one+two
    }
}
