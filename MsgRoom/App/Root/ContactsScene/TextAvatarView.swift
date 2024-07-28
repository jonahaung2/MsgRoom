//
//  TextAvatarView.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 23/7/24.
//

import SwiftUI

struct TextAvatarView: View {
    let text: String
    @State private var words: String?
    var body: some View {
        GeometryReader { geo in
            Circle()
                .fill(Color.secondary)
                .overlay {
                    Text(text.words().compactMap{ $0.first }.prefix(2).map{ String($0).uppercased() }.joined())
                        .font(.system(size: geo.size.height * 0.4, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                }
        }
        .equatable(by: text)
    }
}
