//
//  ChatInteractor.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 8/7/24.
//

import Foundation
import XUI
import SwiftData
import AsyncQueue

final class MsgDatasourceProvider: MsgDatasourceProviding {
    
    var room: Room
    @Injected(\.swiftdataRepo) private var swiftdataRepo
    @Injected(\.swiftDatabase) private var database
    
    init(_ room: Room) {
        self.room = room
    }
    
    @MainActor func loadMoreMsgsIfNeeded(for i: Int) -> [Msg] {
        return msgs(for: i)
    }
    @MainActor
    private func msgs(for i: Int) -> [Msg] {
        let conID = room.id
        var descriptor = FetchDescriptor<MsgData>(
            predicate: #Predicate { $0.conID == conID },
            sortBy: [
                .init(\.date, order: .reverse)
            ]
        )
        descriptor.fetchLimit = i
        descriptor.includePendingChanges = true
        do {
            let existings = try database.container.mainContext.fetch(descriptor)
            return existings.map{ .init(persisted: $0) }
        } catch {
            Log(error)
            return []
        }
    }
    func didReceiveMsg(_ msg: Msg) async {
        switch  await swiftdataRepo.create(msg) {
        case .success(let model):
            break
        case .failure(let error):
            Log(error)
        }
    }
}
