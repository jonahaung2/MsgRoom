//
//  MsgContextMenu.swift
//  Conversation
//
//  Created by Aung Ko Min on 30/1/22.
//

import SwiftUI

struct MsgContextMenu: View {
    
    @Environment(Message.self) private var msg
    
    var body: some View {
        Button(action: {
            
        }) {
    
            Label("Hello", systemImage: "circle.fill")
        }
        
        Button(action: {
//            coordinator.datasource.remove(msg: msg)
        }) {
            Label("Delete", systemImage: "trash.fill")
        }
    }
}
