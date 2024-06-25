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
            case .text, .none:
                ChatInputBarTextView<Msg, Con>()
            }
        }
        .animation(.interactiveSpring(duration: 0.5), value: chatInputBarviewModel.itemType)
        .tint(Color.accentColor.gradient)
        .background(.bar)
        .environmentObject(chatInputBarviewModel)
    }
}
