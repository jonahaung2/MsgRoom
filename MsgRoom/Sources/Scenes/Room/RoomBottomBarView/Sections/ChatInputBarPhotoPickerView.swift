//
//  ChatInputBarPhotoPickerView.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 26/6/24.
//

import SwiftUI
import MediaPicker
import XUI
import Models

struct ChatInputBarPhotoPickerView: View {
    
    @EnvironmentObject private var chatInputBarviewModel: ChatInputBarViewModel
    
    var body: some View {
        VStack {
            InlinePhotoPicker(imageAttachments: $chatInputBarviewModel.imageAttachments)
                .overlay(alignment: .bottom) {
                    HStack {
                        AsyncButton {
                            chatInputBarviewModel.radialItemType = .text
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
                            chatInputBarviewModel.radialItemType = .imageAttachments
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
