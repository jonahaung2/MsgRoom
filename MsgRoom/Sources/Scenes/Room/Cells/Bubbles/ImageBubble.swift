//
//  ImageBubble.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 6/7/24.
//

import SwiftUI
import ImageLoader
import UI
import Models
import Core
struct ImageBubble: View {
    let urlString: String
    let image: UIImage?
    @State var ratio: CGFloat?
    let shape: BubbleShape
    
    var body: some View {
        if let image, let ratio {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(ratio, contentMode: .fit)
                .clipShape(shape)
                .padding(4)
                .equatable(by: urlString)
        } else {
            LazyImage(url: .init(string: urlString), transaction: Transaction.init(animation: .default)) { state in
                if let image = state.image {
                    image
                        .resizable()
                        .clipShape(shape)
                        .padding(4)
                }
            }
            .aspectRatio(ratio, contentMode: .fit)
            .equatable(by: urlString)
        }
    }
}
