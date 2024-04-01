//
//  MsgRoomDatasourceRepresentable.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 1/4/24.
//

import Foundation
import XUI

protocol MsgRoomDatasourceRepresentable: ObservableObject {
    associatedtype MsgItem = Msgable
    var pageSize: Int { get }
    var currentPage: Int { get set }
    var conId: String { get }
    var allMsgs: [MsgItem] { get set }
    func loadMoreIfNeeded() -> Bool
    var msgs: ArraySlice<MsgItem> { get }
    var enuMsgs: Array<(offset: Int, element: MsgItem)> { get }
    init(conId: String)
}
