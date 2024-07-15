//
//  ChatInputBar.swift
//  Msgr
//
//  Created by Aung Ko Min on 21/10/22.
//

import SwiftUI
import XUI
import MediaPicker
import PhotosUI

struct RoomBottomBarView: View {
    
    @EnvironmentObject private var viewModel: RoomViewModel
    @StateObject private var chatInputBarviewModel = ChatInputBarViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            switch chatInputBarviewModel.radialItemType {
            case .photoPicker:
                ChatInputBarPhotoPickerView()
            case .imageAttachments:
                ChatInputBarImageAttachmentsView()
            case .locationPicker:
                Color.blue
            case .videoPicker:
                Color.blue
            case .text:
                ChatInputBarTextView()
            case .emojiPicker:
                EmojiPickerView()
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .animation(.snappy, value: chatInputBarviewModel.radialItemType)
        .environmentObject(chatInputBarviewModel)
    }
}
