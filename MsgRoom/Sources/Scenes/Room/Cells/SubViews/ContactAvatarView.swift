//
//  ContactAvatarView.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 7/4/24.
//

import SwiftUI
import ImageLoader
import UI

public struct ContactAvatarView: View {
    let id: String
    let urlString: String
    
    @State private var image: UIImage?
    let size: CGFloat
    
    init(id: String, urlString: String, image: UIImage? = nil, size: CGFloat) {
        self.id = id
        self.urlString = urlString
        self.image = image
        self.size = size
    }
    public var body: some View {
        LazyResizableImage(url: .init(string: urlString)) { state, proxy in
            state
                .image?.resizable()
                .frame(width: proxy.size.width, height: proxy.size.height)
       }
            .aspectRatio(1, contentMode: .fill)
            .frame(width: size, height: size)
            .clipShape(Circle())
    }
}
