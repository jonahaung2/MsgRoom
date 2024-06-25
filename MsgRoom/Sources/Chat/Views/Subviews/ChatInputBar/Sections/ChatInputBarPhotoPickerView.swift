//
//  ChatInputBarPhotoPickerView.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 26/6/24.
//

import SwiftUI
import MediaPicker
import XUI

struct ChatInputBarPhotoPickerView<Msg: MessageRepresentable, Con: ConversationRepresentable>: View {
    
    @EnvironmentObject private var chatInputBarviewModel: ChatInputBarViewModel
    
    var body: some View {
        VStack {
            InlinePhotoPicker(imageAttachments: $chatInputBarviewModel.imageAttachments)
                .transition(.opacity.animation(.linear(duration: 0.5)))
                .overlay(alignment: .bottom) {
                    HStack {
                        AsyncButton {
                            chatInputBarviewModel.itemType = .none
                        } label: {
                            SystemImage(.xmarkCircleFill, 23)
                        }
                        Spacer()
                        AsyncButton {
                            chatInputBarviewModel.itemType = .imageAttachments
                        } label: {
                            Text("Select these Photos")
                                .font(.headline)
                        }
                        .disabled(chatInputBarviewModel.imageAttachments.isEmpty)
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                    .background(.bar)
                }
        }
        .frame(height: 500)
    }
}