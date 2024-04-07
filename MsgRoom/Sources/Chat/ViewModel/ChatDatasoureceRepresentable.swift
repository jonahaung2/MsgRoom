//
//  MsgRoomDatasourceRepresentable.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 1/4/24.
//

import Foundation
import XUI

protocol ChatDatasoureceRepresentable: ObservableObject {
    associatedtype MsgItem = MessageRepresentable
    associatedtype ConItem = ConversationRepresentable
    
    var con: ConItem { get }
    var pageSize: Int { get }
    var currentPage: Int { get set }
    var allMsgs: [MsgItem] { get set }
    var msgs: ArraySlice<MsgItem> { get }
    var enuMsgs: Array<(offset: Int, element: MsgItem)> { get }
    init(_ conversation: ConItem)
    
    func loadMoreIfNeeded() -> Bool
    func update()
}
