//
//  MsgRoomDatasourceRepresentable.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 12/3/24.
//

import SwiftUI

protocol ChatViewModelImplementation: ObservableObject {
    associatedtype Msg = MsgKind
    typealias MsgPair = (prev: Msg?, msg: Msg, next: Msg?)
    associatedtype Con = ConKind
    var con: Con { get }
    var scrollItem: ScrollItem { get set }
    var selectedId: String? { get set }
    var focusedId: String? { get set }
    var showScrollToLatestButton: Bool { get set }
    var isTyping: Bool { get set }
    
    init(con: Con)
    func didUpdateVisibleRect(_ visibleRect: CGRect)
    func scrollToBottom(_ animated: Bool)
}
