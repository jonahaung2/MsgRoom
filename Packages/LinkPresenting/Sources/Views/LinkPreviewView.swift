//
//  LinkPreviewView.swift
//  LinkPreview
//
//  Created by Created Aung Ko Min on 4/19/23.
//

import SwiftUI

public struct LinkPreviewView: View {
    
    public let linkDataFetcher: LinkDataFetcher
    
    @State private var linkType: LinkType? = nil
    @State private var linkTitle: String? = nil
    @State private var linkImage: String? = nil
    @State private var linkDescription: String? = nil
    @State private var imageWidth: Double? = nil
    @State private var imageHeight: Double? = nil
    @State private var publisher: String? = nil
    @State private var youtubeVideoID: String? = nil
    
    public var tapAction: ((_ linkType: LinkType?,
                     _ link: String,
                     _ publisher: String?,
                     _ linkTitle: String?,
                     _ linkDescription: String?,
                     _ linkImage: String?,
                     _ youtubeVideoID: String?) -> Void)?
    
    public init(linkType: LinkType? = nil,
         linkDataFetcher: LinkDataFetcher,
         linkTitle: String? = nil,
         linkImage: String? = nil,
         linkDescription: String? = nil,
         imageWidth: Double? = nil,
         imageHeight: Double? = nil,
         publisher: String? = nil,
         youtubeVideoID: String? = nil,
         tapAction: (@escaping (_ linkType: LinkType?,
                                _ link: String,
                                _ publisher: String?,
                                _ linkTitle: String?,
                                _ linkDescription: String?,
                                _ linkImage: String?,
                                _ youtubeVideoID: String?) -> Void)) {
        self.linkType = linkType
        self.linkDataFetcher = linkDataFetcher
        self.linkTitle = linkTitle
        self.linkImage = linkImage
        self.linkDescription = linkDescription
        self.imageWidth = imageWidth
        self.imageHeight = imageHeight
        self.publisher = publisher
        self.youtubeVideoID = youtubeVideoID
        self.tapAction = tapAction
    }
    
    public init(linkType: LinkType? = nil,
         linkDataFetcher: LinkDataFetcher,
         linkTitle: String? = nil,
         linkImage: String? = nil,
         linkDescription: String? = nil,
         imageWidth: Double? = nil,
         imageHeight: Double? = nil,
         publisher: String? = nil,
         youtubeVideoID: String? = nil) {
        self.linkType = linkType
        self.linkDataFetcher = linkDataFetcher
        self.linkTitle = linkTitle
        self.linkImage = linkImage
        self.linkDescription = linkDescription
        self.imageWidth = imageWidth
        self.imageHeight = imageHeight
        self.publisher = publisher
        self.youtubeVideoID = youtubeVideoID
    }
    
    public init(linkType: LinkType? = nil,
         linkDataFetcher: LinkDataFetcher,
         linkTitle: String? = nil,
         linkImage: String? = nil,
         linkDescription: String? = nil,
         imageWidth: Double? = nil,
         imageHeight: Double? = nil,
         publisher: String? = nil,
         youtubeVideoID: String? = nil,
         tapAction: ((_ linkType: LinkType?,
                      _ link: String,
                      _ publisher: String?,
                      _ linkTitle: String?,
                      _ linkDescription: String?,
                      _ linkImage: String?,
                      _ youtubeVideoID: String?) -> Void)?) {
        self.linkType = linkType
        self.linkDataFetcher = linkDataFetcher
        self.linkTitle = linkTitle
        self.linkImage = linkImage
        self.linkDescription = linkDescription
        self.imageWidth = imageWidth
        self.imageHeight = imageHeight
        self.publisher = publisher
        self.youtubeVideoID = youtubeVideoID
        self.tapAction = tapAction
    }
    
    
    public var body: some View {
        VStack {
            if let linkType = linkType {
                switch linkType {
                case .normal:
                    if let linkImage = linkImage, let imageWidth = imageWidth, let imageHeight = imageHeight {
                        AsyncImage(url: URL(string: linkImage)) { phase in
                            switch phase {
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(imageWidth/imageHeight, contentMode: .fit)
                                    .imageScale(.small)
                            case .empty, .failure:
                                Text(.init(linkImage))
                            @unknown default:
                                EmptyView().hidden()
                            }
                        }
                    }
                case .video:
                    VStack(spacing: 0) {
                        if let youtubeVideoID = self.youtubeVideoID {
                            YouTubeVideoView(youtubeVideoID: youtubeVideoID)
                        }
                    }
                case .tweet:
                    if let tweetURL = URL(string: linkDataFetcher.link) {
                        TweetView(previewURL: tweetURL)
                            .aspectRatio(contentMode: .fit)
                    }
                }
            }
            
        }
        .onAppear {
            linkDataFetcher.fetchLinkData(completionBlock: { linkType, publisher, title, imageURL, description, imageWidth, imageHeight, youtubeVideoID  in
                self.publisher = publisher
                self.linkTitle = title
                self.linkImage = imageURL
                self.linkDescription = description
                self.imageWidth = imageWidth
                self.imageHeight = imageHeight
                self.linkType = linkType
                self.youtubeVideoID = youtubeVideoID
            })
        }
        .onTapGesture {
            if let tapAction {
                tapAction(linkType, linkDataFetcher.link, publisher, linkTitle, linkDescription, linkImage, youtubeVideoID)
            }
        }
    }
}

struct LinkPreviewView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LinkPreviewView(linkDataFetcher: LinkDataFetcher(link:"https://www.politico.eu/article/eu-schemes-up-sweeteners-to-woo-countries-from-russia-and-china/"))
        }
    }
}
