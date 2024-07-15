//
//  LinkPreviewView.swift
//  LinkPreview
//
//  Created by Created Aung Ko Min on 4/19/23.
//

import SwiftUI

public struct LinkPreviewView: View {
    
    let linkDataFetcher: LinkDataFetcher
    
    @State private var linkType: LinkType? = nil
    @State private var linkTitle: String? = nil
    @State private var linkImage: String? = nil
    @State private var linkDescription: String? = nil
    @State private var imageWidth: Double? = nil
    @State private var imageHeight: Double? = nil
    @State private var publisher: String? = nil
    @State private var youtubeVideoID: String? = nil
    
    var tapAction: ((_ linkType: LinkType?,
                     _ link: String,
                     _ publisher: String?,
                     _ linkTitle: String?,
                     _ linkDescription: String?,
                     _ linkImage: String?,
                     _ youtubeVideoID: String?) -> Void)?
    
    init(linkType: LinkType? = nil,
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
    
    init(linkType: LinkType? = nil,
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
    
    init(linkType: LinkType? = nil,
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
        ZStack {
            if let linkType = linkType {
                switch linkType {
                case .normal:
                    VStack(spacing: 0) {
                        if let linkImage = linkImage, let imageWidth = imageWidth, let imageHeight = imageHeight {
                            AsyncImage(url: URL(string: linkImage)) { phase in
                                switch phase {
                                case .success(let image):
                                    image
                                        .resizable()
                                        .aspectRatio(imageWidth/imageHeight, contentMode: .fit)
                                case .empty, .failure:
                                    Rectangle()
                                        .aspectRatio(imageWidth/imageHeight, contentMode: .fit)
                                        .foregroundColor(.Shadow.main)
                                @unknown default:
                                    EmptyView()
                                }
                            }
                        }
                        VStack(alignment: .leading, spacing: 0) {
                            if let publisher {
                                Text(publisher)
                                    .lineLimit(1)
                                    .padding([.leading, .trailing])
                            }
                            
                            if let linkTitle {
                                Text(linkTitle)
                                    .lineLimit(1)
                                    .padding([.leading, .trailing])
                            }
                            if let linkDescription {
                                Text(linkDescription)
                                    .padding([.leading, .trailing])
                                    .lineLimit(2)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.vertical, 8)
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
        .frame(maxWidth: .infinity)
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
