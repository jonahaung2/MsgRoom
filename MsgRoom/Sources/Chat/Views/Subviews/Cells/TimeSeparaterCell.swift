//
//  TimeSeparaterCell.swift
//  Conversation
//
//  Created by Aung Ko Min on 13/2/22.
//

import SwiftUI
import XUI

struct TimeSeparaterCell: View {
    
    let date: Date
    
    var body: some View {
        ZStack {
            Text(date.formatted(date: .abbreviated, time: .shortened))
                .font(.system(size: UIFont.systemFontSize, design: .rounded))
        }
        .frame(height: 50)
        .foregroundStyle(.tertiary)
        .equatable(by: date)
    }
}
