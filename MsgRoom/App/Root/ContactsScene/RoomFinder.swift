//
//  RoomFinder.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 3/7/24.
//

import Foundation
import SwiftData
import XUI

struct RoomFinder {
    @Injected(\.swiftdataRepo) private var swiftdataRepo
    @MainActor
    func getOrCreateRoomFor(for contact: PersistedContact, context: ModelContext) async throws -> Room {
        let id = getRoomId(for: CurrentUser.current.id, two: contact.id)
        if let found = PersistedRoom.fetch(for: id, context: context) {
            return .init(persisted: found)
        }
        let room = PersistedRoom(id: id, name: contact.name, type: .single, createdDate: .now, photoURL: DemoImages.demoPhotosURLs.random()?.absoluteString)
        contact.modelContext?.insert(room)
        room.contacts?.append(contact)
        try contact.modelContext?.save()
        return .init(persisted: room)
    }
    private func getRoomId(for one: String, two: String) -> String  {
        one > two ? two+one : one+two
    }
}
