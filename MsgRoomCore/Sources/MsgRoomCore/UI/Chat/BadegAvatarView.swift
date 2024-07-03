//
//  SwiftUIView.swift
//  
//
//  Created by Aung Ko Min on 3/7/24.
//

import SwiftUI
import XUI

struct BadegAvatarView: View {
    let urlString: String
    let size: CGFloat
    
    var body: some View {
        Gauge(value: 5, in: 0...10) {
            ContactAvatarView(id: "", urlString: urlString, size: size)
        }
        .gaugeStyle(.accessoryCircularCapacity)
        .tint(Color.orange)
        .frame(square: size)
        .equatable(by: urlString)
    }
}
