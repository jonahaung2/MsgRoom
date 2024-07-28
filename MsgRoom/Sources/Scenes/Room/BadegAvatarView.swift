//
//  SwiftUIView.swift
//
//
//  Created by Aung Ko Min on 3/7/24.
//

import SwiftUI
import XUI
import UI
import ImageLoaderUI

struct BadegAvatarView: View {
    let urlString: String
    let size: CGFloat
    
    var body: some View {
        LazyImage(url: .init(string: urlString))
            .frame(square: size)
            .clipShape(Circle())
            .equatable(by: urlString)
    }
}
