//
//  MsgRoomDatasourceRepresentable.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 12/3/24.
//

import SwiftUI

protocol MsgRoomViewModelRepresentable: ObservableObject {
    
    associatedtype ConItem = Conversationable
    
    var con: ConItem { get }
    var scrollItem: ScrollItem? { get set }
    var selectedId: String? { get set }
    var showScrollToLatestButton: Bool { get set }
    var isTyping: Bool { get set }
    
    init(con: ConItem)
    
    func didUpdateVisibleRect(_ visibleRect: CGRect)
    func scrollToBottom(_ animated: Bool)
}
