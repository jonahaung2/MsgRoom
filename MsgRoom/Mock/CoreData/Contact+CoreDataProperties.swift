//
//  Contact+CoreDataProperties.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 27/6/24.
//
//

import Foundation
import CoreData


extension Contact {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Contact> {
        return NSFetchRequest<Contact>(entityName: "Contact")
    }

    @NSManaged public var id: String
    @NSManaged public var mobile: String?
    @NSManaged public var name: String?
    @NSManaged public var photoURL: String?
    @NSManaged public var pushToken: String?

}

extension Contact : Identifiable {

}
