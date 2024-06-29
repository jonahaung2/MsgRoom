//
//  PhoneContacts.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 27/6/24.
//

import Foundation
import Contacts
import XUI

enum PhoneContacts {
    static func fetchContacts() throws -> [CNContact] {
        let contactStore = CNContactStore()
        let keysToFetch = [
            CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
            CNContactPhoneNumbersKey,
            CNContactThumbnailImageDataKey
        ] as [Any]
        let allContainers = try contactStore.containers(matching: nil)
        var results: [CNContact] = []
        for container in allContainers {
            let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)
            let containerResults = try contactStore.unifiedContacts(matching: fetchPredicate, keysToFetch: keysToFetch as! [CNKeyDescriptor])
            results.append(contentsOf: containerResults)
        }
        return results
    }
}

extension Contact {
    convenience init?(cnContact: CNContact) {
        let name = cnContact.givenName.isEmpty ? cnContact.middleName + cnContact.familyName : cnContact.givenName
        if name.isWhitespace || cnContact.phoneNumbers.isEmpty {
            return nil
        }
        let phone = cnContact.phoneNumbers.first?.value.stringValue ?? ""
        self.init(id: UUID().uuidString, name: name, phoneNumber: phone, photoUrl: DemoImages.demoPhotosURLs.random()!.absoluteString, pushToken: Lorem.random)
    }
}
