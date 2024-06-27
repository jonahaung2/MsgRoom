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

struct ChatInputBar<Msg: MessageRepresentable, Con: ConversationRepresentable>: View {
    
    @EnvironmentObject private var viewModel: MsgRoomViewModel<Msg, Con>
    @StateObject private var chatInputBarviewModel = ChatInputBarViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            switch chatInputBarviewModel.itemType {
            case .photoPicker:
                ChatInputBarPhotoPickerView<Msg, Con>()
            case .imageAttachments:
                ChatInputBarImageAttachmentsView()
            case .locationPicker:
                EmptyView()
            case .videoPicker:
                EmptyView()
            case .text:
                ChatInputBarTextView<Msg, Con>()
            }
        }
        .animation(.linear(duration: 0.3), value: chatInputBarviewModel.itemType)
        .symbolRenderingMode(.multicolor)
        .tint(Color.accentColor.gradient)
        .background()
        .environmentObject(chatInputBarviewModel)
    }
}
