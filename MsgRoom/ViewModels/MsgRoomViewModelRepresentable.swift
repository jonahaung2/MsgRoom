//
//  MsgRoomDatasourceRepresentable.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 12/3/24.
//

import SwiftUI

protocol MsgRoomViewModelRepresentable: ObservableObject {
    var con: any Conversationable { get }
    var scrollItem: ScrollItem? { get set }
    var selectedId: String? { get set }
    var showScrollToLatestButton: Bool { get set }
    var isTyping: Bool { get set }
    
    init(_con: any Conversationable)
    
    func didUpdateVisibleRect(_ visibleRect: CGRect)
    func scrollToBottom(_ animated: Bool)
}
