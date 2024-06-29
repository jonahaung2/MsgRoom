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
    
    @ObservationIgnored
    let database: SwiftDatabase
    
    init() {
        @Injected(\.swiftDatabase) var database
        self.database = database
    }
    func insert(_ model: Contact) async {
        await database.actor.insert(model)
    }
    func deleteData(_ model: Contact) async {
        await database.actor.delete(model)
        try? await database.actor.save()
    }
}
