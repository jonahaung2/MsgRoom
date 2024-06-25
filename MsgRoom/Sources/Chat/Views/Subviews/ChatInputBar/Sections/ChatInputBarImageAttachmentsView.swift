//
//  ChatInputBarImageAttachmentsView.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 26/6/24.
//

import SwiftUI
import MediaPicker
import XUI

struct ChatInputBarImageAttachmentsView: View {
    @EnvironmentObject private var chatInputBarviewModel: ChatInputBarViewModel
    
    var body: some View {
        VStack(spacing: 7) {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack {
                    ForEach(chatInputBarviewModel.imageAttachments, id: \.id) { each in
                        ImageAttachmentViewerView(imageAttachment: each)
                            ._flexible(.vertical)
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                            .overlay(alignment: .topTrailing) {
                                _ConfirmButton("Delete this photo") {
                                    if let i = chatInputBarviewModel.imageAttachments.firstIndex(where: { item in
                                        item.id == each.id
                                    }) {
                                        chatInputBarviewModel.imageAttachments.remove(at: i)
                                        if chatInputBarviewModel.imageAttachments.isEmpty {
                                            chatInputBarviewModel.itemType = .text
                                        }
                                    }
                                } label: {
                                    SystemImage(.minusCircleFill, 18)
                                        .symbolRenderingMode(.multicolor)
                                        .padding(.bottom)
                                        .padding(.leading)
                                }
                            }
                    }
                }.padding(.horizontal)
            }
            .animation(.interactiveSpring(duration: 0.5), value: chatInputBarviewModel.imageAttachments.count)
            HStack {
                Button {
                    chatInputBarviewModel.itemType = .text
                } label: {
                    SystemImage(.xmarkCircleFill, 23)
                }
                Spacer()
                SendButton {
                    print("send")
                }
            }
            .padding()
        }
        .padding(.vertical)
        .frame(height: 280)
        .background(.bar)
        .overlay(alignment: .top) {
            Divider()
        }
    }
}
