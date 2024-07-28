//
//  RadialLayoutView.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 4/7/24.
//

import SwiftUI
import XUI
import Models
import EmojiKit

struct RadialLayoutView: View {
    @State private var count = 5
        var body: some View {
            ScrollView {
                RadialLayout {
                    ForEach(0..<count, id: \.self) { _ in
                        Circle()
                            .frame(width: 30, height: 30)
                    }
                }
                .frame(square: 250)
                .safeAreaInset(edge: .bottom) {
                    Stepper("Count: \(count)", value: $count.animation(), in: 0...36)
                        .padding()
                }
            }
        }
}
