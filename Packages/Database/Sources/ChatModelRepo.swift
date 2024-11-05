//
//  PersistentModelRepo.swift
//  Database
//
//  Created by Aung Ko Min on 29/10/24.
//

import SwiftData
import Models

public struct ChatModelRepo<T: PModelProxy> where T.Persistent.ID == String {
    
    public init() {}
    public static func fetch(id: String, repo: ChatDataReposity) async -> T? {
        await repo.fetch(id: id)
    }
    public static func fetch(ids: [String], repo: ChatDataReposity) async -> [T] {
        var items = [T]()
        await withTaskGroup(of: T?.self) { tasks in
            for id in ids {
                tasks.addTask {
                    return await repo.fetch(id: id)
                }
            }
            for await item in tasks {
                if let item {
                    items.append(item)
                }
            }
        }
        return items
    }
    
    @discardableResult
    public func update(_ model: T, repo: ChatDataReposity) async  -> T? {
        switch await repo.update(model) {
        case .success(let updated):
            return updated
        case .failure(let error):
            print(error)
            return nil
        }
    }
    public func reload(_ model: T, repo: ChatDataReposity) async -> T? {
        await repo.fetch(id: model.id)
    }
}
