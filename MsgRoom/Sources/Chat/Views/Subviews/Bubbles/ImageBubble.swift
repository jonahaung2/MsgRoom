//
//  ImageBubble.swift
//  Conversation
//
//  Created by Aung Ko Min on 31/1/22.
//

import SwiftUI
import URLImage

struct ImageBubble: View {

    let style: MsgDecoration
    
    var body: some View {
        URLImage(url: .init(string: style.text), quality: .resized(200)) { state in
            ZStack {
                if let image = state.image {
                    image
                        .resizable()
                        .scaledToFit()
                        .clipShape(style.bubbleShape)
                } else {
                    ProgressView()
                }
            }
            .frame(maxWidth: MsgStyleStylingWorker.Constants.mediaMaxWidth)
        }
    }
}
