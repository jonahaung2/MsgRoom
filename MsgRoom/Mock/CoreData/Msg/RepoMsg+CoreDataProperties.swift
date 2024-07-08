//
//  Msg+CoreDataProperties.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 27/6/24.
//
//

import Foundation
import CoreData
import XUI

extension RepoMsg {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<RepoMsg> {
        return NSFetchRequest<RepoMsg>(entityName: "RepoMsg")
    }
    @NSManaged public var conID: String
    @NSManaged public var date: Date
    @NSManaged public var deliveryStatus_: Int16
    @NSManaged public var id: String
    @NSManaged public var msgKind_: Int16
    @NSManaged public var senderID: String
    @NSManaged public var text: String
}

extension RepoMsg {
    public var msgKind: MsgKind {
        .init(rawValue: msgKind_) ?? .Text
    }
    public var deliveryStatus: MsgDelivery {
        get { .init(rawValue: deliveryStatus_) ?? .Sending }
        set { deliveryStatus_ = newValue.rawValue }
    }
}
