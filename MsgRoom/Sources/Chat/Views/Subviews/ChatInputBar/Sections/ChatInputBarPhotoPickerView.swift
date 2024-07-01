//
//  ChatInputBarPhotoPickerView.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 26/6/24.
//

import SwiftUI
import MediaPicker
import XUI

struct ChatInputBarPhotoPickerView<Msg: MsgRepresentable, Room: RoomRepresentable, Contact: ContactRepresentable>: View {
    
    @EnvironmentObject private var chatInputBarviewModel: ChatInputBarViewModel
    
    var body: some View {
        VStack {
            InlinePhotoPicker(imageAttachments: $chatInputBarviewModel.imageAttachments)
                .overlay(alignment: .bottom) {
                    HStack {
                        AsyncButton {
                            chatInputBarviewModel.itemType = .text
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
