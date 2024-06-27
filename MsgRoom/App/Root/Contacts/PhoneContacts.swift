//
//  PhoneContacts.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 27/6/24.
//

import Foundation
import Contacts
import XUI

class PhoneContacts {
    var contacts = [Contact]()
    func fetchContacts() throws {
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
        var contacts = [Contact]()
        results.forEach { each in
//            let x = Contact(id: each.identifier, name: each.givenName, phoneNumber: each.phoneNumbers.first?.value.stringValue ?? "", photoUrl: DemoImages.demoPhotosURLs.random()!.absoluteString, pushToken: Lorem.random)
//            contacts.append(x)
        }
        self.contacts = contacts
    }
}
