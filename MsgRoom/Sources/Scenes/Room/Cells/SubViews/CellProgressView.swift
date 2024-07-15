//
//  CellProgressView.swift
//  Conversation
//
//  Created by Aung Ko Min on 17/2/22.
//

import SwiftUI

struct CellProgressView: View {
    
    let progress: MsgDeliveryStatus
    
    var body: some View {
        Circle().fill(Color(uiColor: .opaqueSeparator))
//        Image(systemName: "circle.fill")
//            .resizable()
//            .scaledToFit()
//            .foregroundStyle(Color(uiColor: .opaqueSeparator))
            .frame(square: 10)
    }
}
