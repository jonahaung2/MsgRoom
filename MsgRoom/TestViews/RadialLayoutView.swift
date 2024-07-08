//
//  RadialLayoutView.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 4/7/24.
//

import SwiftUI
import XUI

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
                FlowLayout {
                    ForEach(Emojis.values, id: \.count) { each in
                        
                        ForEach(each, id: \.id) { emoji in
                            
                            ZStack {
                                Text(emoji)
                                    .font(.largeTitle)
                            }
                            .frame(square: 44)
                        }
                        
                    }
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
            
            
        }
}
