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

struct ChatInputBar<Msg: MsgRepresentable, Room: RoomRepresentable, Contact: ContactRepresentable>: View {
    
    @EnvironmentObject private var viewModel: MsgRoomViewModel<Msg, Room, Contact>
    @StateObject private var chatInputBarviewModel = ChatInputBarViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            switch chatInputBarviewModel.itemType {
            case .photoPicker:
                ChatInputBarPhotoPickerView<Msg, Room, Contact>()
            case .imageAttachments:
                ChatInputBarImageAttachmentsView<Msg, Room, Contact>()
            case .locationPicker:
                Color.blue
            case .videoPicker:
                Color.blue
            case .text:
                ChatInputBarTextView<Msg, Room, Contact>()
            }
        }
        .padding(.top, 5)
        .symbolRenderingMode(.multicolor)
        .tint(Color.accentColor.gradient)
        .background()
        .environmentObject(chatInputBarviewModel)
    }
}
