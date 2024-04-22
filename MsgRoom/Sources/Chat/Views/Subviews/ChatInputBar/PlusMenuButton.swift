//
//  LeftMenuButton.swift
//  Conversation
//
//  Created by Aung Ko Min on 31/1/22.
//

import SwiftUI
import XUI
import Symbols
import MediaPicker
import AVFoundation

struct PlusMenuButton: View {
    
    @EnvironmentObject private var viewModel: MsgRoomViewModel<Message>
    @State private var image: UIImage?
    @State private var videoAsset: AVAsset?
    
    var body: some View {
        HStack {
            PhotoPickupButton(pickedImage: $image) { status in
                switch status {
                case .empty:
                    SystemImage(.photoCircleFill, 35)
                case .loading(let loading):
                    ProgressView()
                case .success(let item):
                    Image(uiImage: item)
                        .resizable()
                        .frame(square: 35)
                        .clipShape(Circle())
                case .failure(_):
                    SystemImage(.boltCircleFill, 35)
                }
            }
            VideoPickupButton(pickedVideo: $videoAsset) { status in
                switch status {
                case .empty:
                    SystemImage(.videoCircleFill, 35)
                case .loading(let progress):
                    ProgressView()
                case .success(let item):
                    SystemImage(.videoCircle, 35)
                case .failure(_):
                    SystemImage(.boltCircleFill, 35)
                }
            }
        }
        .symbolRenderingMode(.hierarchical)
        .fontWeight(.light)
        .tint(.primary)
    }
}
