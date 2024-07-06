//
//  SwiftUIView.swift
//
//
//  Created by Aung Ko Min on 3/7/24.
//

import SwiftUI
import XUI
import ImageLoader
import URLImage

struct BadegAvatarView: View {
    let urlString: String
    let size: CGFloat
    
    var body: some View {
        URLImage(url: .init(string: urlString), quality: .resized(size))
            .frame(square: size)
            .clipShape(Circle())
            .equatable(by: urlString)
    }
}
