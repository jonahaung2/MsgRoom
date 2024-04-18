//
//  MsgRoomDatasourceRepresentable.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 1/4/24.
//

import Foundation
import XUI

protocol ChatDatasoureceRepresentable: ObservableObject {
    
    associatedtype MsgItem = MsgKind
    associatedtype ConItem = ConKind
    typealias MsgPair = (prev: MsgItem?, msg: MsgItem, next: MsgItem?)
    
    var con: ConItem { get }
    
    var blocks: [MsgPair] { get set }
    var allMsgsCount: Int { get set }
    var isFetching: Bool { get set }
    
    var pageSize: Int { get }
    var currentPage: Int { get set }
    var allMsgs: [MsgItem] { get set }
//    var msgs: ArraySlice<MsgItem> { get }
//    var enuMsgs: Array<(offset: Int, element: MsgItem)> { get }
    init(_ conversation: ConItem)
    
    func loadMoreIfNeeded(_ block: (() -> Void)?)
    func update()
}
