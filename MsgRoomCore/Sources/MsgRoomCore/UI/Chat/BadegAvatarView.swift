//
//  SwiftUIView.swift
//  
//
//  Created by Aung Ko Min on 3/7/24.
//

import SwiftUI
import XUI
import URLImage

struct BadegAvatarView: View {
    let urlString: String
    let size: CGFloat
    
    var body: some View {
        ZStack(alignment: .center) {
            SystemImage(.circleDashed, size+5)
//                .phaseAnimation([.rotate(.north), .rotate(.north_360)])
            ContactAvatarView(id: "", urlString: urlString, size: size)
                .clipShape(Circle())
        }
        .fontWeight(.thin)
        .foregroundStyle(Color.orange)
        .frame(square: size)
        .equatable(by: urlString)
    }
}
