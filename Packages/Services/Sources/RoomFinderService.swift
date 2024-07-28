//
//  RoomFinder.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 3/7/24.
//

import Foundation
import Models
import Database

public struct RoomFinderService {
    @Injected(\.swiftdataRepo) private var swiftdataRepo
    @MainActor public
    func getOrCreateRoomFor(for contact: Contact) async throws -> Room {
        let id = getRoomId(for: CurrentUser.current.id, two: contact.id)
        var room = Room(id: id, name: contact.name, type: .single, createdDate: .now, photoURL: contact.photoURL, contactspersistentIds: [])
        room.contacts.append(contact)
        switch await swiftdataRepo.create(room) {
        case .success(let room):
            return room
        case .failure(let error):
            throw error
        }
    }
    private func getRoomId(for one: String, two: String) -> String  {
        one > two ? two+one : one+two
    }
    
    public init() {}
}
