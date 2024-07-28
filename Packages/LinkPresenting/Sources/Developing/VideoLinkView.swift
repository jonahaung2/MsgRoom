//
//  VideoLinkView.swift
//  LinkPreview
//
//  Created Created Aung Ko Min
//  4/24/23.
//

import SwiftUI
import AVKit
import UIKit

struct VideoLinkView: View {
    
    private let demoVideoLink: String = "https://github.com/HuangRunHua/Mac-Charge-Monitor/raw/main/Mac%20Charge%20Monitor/Resources/macbookair.mov"
    
    @State private var videoResolution: CGFloat? = nil
    @State private var linkTitle: String? = nil
    @State private var linkDescription: String? = nil
    @State private var publisher: String? = nil
    @State private var showPlayButton: Bool = true
    @State private var isVideoPlaying: Bool = false
    
    private var player: AVPlayer? {
        if let videoURL = URL(string: demoVideoLink) {
            return AVPlayer(url: videoURL)
        }
        return nil
    }
    
    var body: some View {
        VStack(spacing: 0) {
            if let videoResolution, let player {
                ZStack(alignment: .bottomTrailing) {
                    VideoPlayer(player: player)
                }
                .onAppear {
                    player.seek(to: CMTimeMakeWithSeconds(0.7, preferredTimescale: 1000))
                }
                .aspectRatio(videoResolution, contentMode: .fit)
                .overlay(
                    RoundedRectangle(cornerRadius: 0)
                        .stroke(Color.secondary, lineWidth: 2)
                )
            }
            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    if let publisher {
                        Text(publisher)
                            .lineLimit(1)
                            .padding([.leading, .trailing])
                            .font(.headline)
                    }
                    Spacer()
                    Text("Video")
                        .lineLimit(1)
                        .padding([.leading, .trailing])
                        .font(.footnote)
                        .foregroundColor(.primary)
                        .overlay(
                            RoundedRectangle(cornerRadius: 2)
                                .stroke(Color.secondary, lineWidth: 2)
                        )
                        .padding(.trailing)
                }
                if let linkTitle {
                    Text(linkTitle)
                        .padding([.leading, .trailing])
                }
                
                if let linkDescription {
                    Text(linkDescription)
                        .foregroundColor(.primary)
                        .padding([.leading, .trailing])
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding([.bottom])
            .padding(.top, 10)
            .background(Color(uiColor: .quaternarySystemFill))
        }
        .frame(maxWidth: .infinity)
        .onAppear {
            self.publisher = "economist.com"
            self.linkTitle = "How to worry wisely about artificial intelligence"
            self.linkDescription = "Rapid progress in AI is arousing fear as well as excitement. How worried should you be?"
            self.videoResolution = self.getVideoWidthResolution(url: self.demoVideoLink)
        }
    }
    
    func getVideoWidthResolution(url: String) -> CGFloat? {
        guard let track = AVURLAsset(url: URL(string: url)!).tracks(withMediaType: AVMediaType.video).first else { return nil}
        let size = track.naturalSize.applying(track.preferredTransform)
        return abs(size.width)/abs(size.height)
    }
}
extension VideoLinkView {
    var playButton: some View {
        Button {
            self.player?.play()
        } label: {
            ZStack {
                Circle()
                    .foregroundColor(.white)
                    .frame(width: 50)
                Circle()
                    .foregroundColor(.blue)
                    .frame(width: 40)
                Image(systemName: "play.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.white)
                    .frame(width: 17)
                    .offset(x: 2)
            }
        }
    }
}

struct VideoLinkView_Previews: PreviewProvider {
    static var previews: some View {
        VideoLinkView()
    }
}
