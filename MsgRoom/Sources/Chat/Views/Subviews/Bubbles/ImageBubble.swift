//
//  ImageBubble.swift
//  Conversation
//
//  Created by Aung Ko Min on 31/1/22.
//

import SwiftUI
import URLImage

struct ImageBubble: View {
    
//    @Environment(Message.self) private var msg
//
    let style: MsgDecoration
    
    var body: some View {
//        AsyncImage(url: .init(string: style.text)) { image in
//            image.resizable().scaledToFit()
//                .clipShape(style.bubbleShape)
//        } placeholder: {
//            Color.gray
//                .clipShape(style.bubbleShape)
//        }.frame(maxWidth: 260)

        URLImage(url: .init(string: style.text), quality: .resized(500)) { state in
            ZStack {
                if let image = state.image {
                    image
                        .resizable()
                        .scaledToFit()
                        .clipShape(style.bubbleShape)
                } else {
                    Color.gray
                        .frame(height: 150)
                    ProgressView()
                }
            }
            .frame(maxWidth: 260)
        }
//        Group {
//            if let image = msg.imageData?.image {
//                Image(uiImage: image)
//                    .resizable()
//                    .cornerRadius(8)
//                    .tapToPresent(ImageViewer(image: image))
//            } else {
//                VStack {
//                    ProgressView("\(msg.mediaStatus.rawValue)")
//                }.task {
//                    if msg.mediaStatus == .Unknown {
//                        await PhotoLoader.start(msg)
//                    }
//                }
//            }
//        }
//        .frame(width: ChatKit.mediaMaxWidth, height: ChatKit.mediaMaxWidth * 1/msg.imageRatio)
    }
}
