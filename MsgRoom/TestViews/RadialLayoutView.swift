//
//  RadialLayoutView.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 4/7/24.
//

import SwiftUI
import XUI

struct RadialLayoutView: View {
    @State private var count = 16

        var body: some View {
            ScrollView {
                FlowLayout {
                            ForEach(0..<500) { _ in
                                Group {
                                    Rectangle().fill(Color.allCases.random()!)
                                        .frame(size: .init(width: [40, 50, 60].random()!, height: [40, 50, 60].random()!))
                                    Rectangle().fill(Color.allCases.random()!)
                                        .frame(size: .init(width: [40, 50, 60].random()!, height: [40, 50, 60].random()!))
                                    Rectangle().fill(Color.allCases.random()!)
                                        .frame(size: .init(width: [40, 50, 60].random()!, height: [40, 50, 60].random()!))
                                }
                                .border(Color.red)
                            }
                        }
            }
            
//            RadialLayout {
//                ForEach(0..<count, id: \.self) { _ in
//                    Circle()
//                        .frame(width: 32, height: 32)
//                }
//            }
//            .safeAreaInset(edge: .bottom) {
//                Stepper("Count: \(count)", value: $count.animation(), in: 0...36)
//                    .padding()
//            }
        }
}
