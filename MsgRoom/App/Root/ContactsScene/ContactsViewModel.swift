//
//  ContactsViewModel.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 23/7/24.
//

import Foundation
import Models
import SwiftData
import Database
import Services
import Core
import XUI

@Observable
final class ContactsViewModel {
    
    var groups = [(String, [Contact])]()
    
    init() {}
    
    func fetch() async {
        @Injected(\.swiftdataRepo) var swiftdataRepo
        let descriptor: FetchDescriptor<PersistedContact> = FetchDescriptor()
        let result: Result<[Contact], SwiftDataRepository.Failure> = await swiftdataRepo.fetch(descriptor)
        switch result {
        case .success(let success):
            let group = success.groupByKey(keyPath: \.firstCharacter)
            let items = group.map{ ($0.key, $0.value)}
            self.groups = items.sorted(by: { lhs, rhs in
                lhs.0 < rhs.0
            })
        case .failure(let failure):
            groups = .init()
        }
    }
    func syncContacts() async {
        @Injected(\.swiftdataRepo) var swiftdataRepo
        "".isWhitespace
        do {
            try await PhoneContactsService.fetchContacts().concurrentForEach { cnContact in
                if var contact = Contact(cnContact: cnContact) {
                    contact.photoURL = DemoImages.demoPhotosURLs.random()?.absoluteString ?? ""
                    _ = await swiftdataRepo.create(contact)
                }
            }
            try await Task.sleep(seconds: 2)
            await fetch()
        } catch {
            Log(error)
        }
    }
    func delete(contact: Contact) async {
        @Injected(\.swiftdataRepo) var swiftdataRepo
        if let id = contact.persistentId {
            switch await swiftdataRepo.delete(identifier: id) {
            case .success:
                await fetch()
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension Contact {
    var firstCharacter: String {
        if let first = name.first {
            return String(first).uppercased()
        }
        return ""
    }
}
