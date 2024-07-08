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
                            SystemImage(.quoteOpening, 25)
                        }
                        Spacer()
                        Button {
                            chatInputBarviewModel.imageAttachments.removeAll()
                        } label: {
                            Text("Clear")
                        }
                        .disabled(chatInputBarviewModel.imageAttachments.isEmpty)
                        Spacer()
                        AsyncButton {
                            chatInputBarviewModel.itemType = .imageAttachments
                        } label: {
                            Text("Done")
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
