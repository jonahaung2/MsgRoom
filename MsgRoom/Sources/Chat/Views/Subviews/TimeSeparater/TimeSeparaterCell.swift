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
        Text(date.toString(dateStyle: .medium, timeStyle: .short) ?? "")
            .font(.system(size: UIFont.systemFontSize, weight: .medium))
            .frame(height: 50)
            .foregroundStyle(.tertiary)
    }
}
