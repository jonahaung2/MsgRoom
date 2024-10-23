//
//  File.swift
//  
//
//  Created by Aung Ko Min on 29/7/24.
//

import Foundation
import Models

public extension ChatMsg {
    @MainActor func sender() -> MsgRoomContact? {
        PersistedContact.fetch(for: senderID)
    }
}
