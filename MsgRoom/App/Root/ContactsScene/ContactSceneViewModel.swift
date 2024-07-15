//
//  ContactSceneViewModel.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 29/6/24.
//

import Foundation
import XUI
import SwiftData

@Observable
final class ContactSceneViewModel: ViewModel {
    
    var alert: XUI._Alert?
    var loading: Bool = false

    func insert(_ model: PersistedContact) async {
        @Injected(\.swiftDatabase) var database
        await database.actor.insert(model)
    }
    func deleteData(_ model: PersistedContact) async {
        @Injected(\.swiftDatabase) var database
        await database.actor.delete(model)
        try? await database.actor.save()
    }
}
