//
//  ChatInputBarImageAttachmentsView.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 26/6/24.
//

import SwiftUI
import MediaPicker
import XUI

struct ChatInputBarImageAttachmentsView<Msg: MsgRepresentable, Room: RoomRepresentable, Contact: ContactRepresentable>: View {
    @EnvironmentObject private var chatInputBarviewModel: ChatInputBarViewModel
    @EnvironmentObject private var viewModel: MsgRoomViewModel<Msg, Room, Contact>
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
                }.padding()
            }
            .animation(.interactiveSpring(duration: 0.5), value: chatInputBarviewModel.imageAttachments.count)
            .frame(maxHeight: 150)
            HStack {
                Button {
                    chatInputBarviewModel.itemType = .text
                } label: {
                    SystemImage(.xmarkCircleFill, 23)
                }
                Spacer()
                SendButton {
                    await chatInputBarviewModel.imageAttachments.concurrentForEach { each in
                        if let status = await each.imageStatus {
                            switch status {
                            case .loading:
                                break
                            case .finished(let uIImage):
                                do {
                                    let id = UUID().uuidString
                                    if let url = try await uIImage.temporaryLocalFileUrl(id: id, quality: 0.5) {
                                        if let msg = try await Msg.create(conId: viewModel.datasource.room.id, date: .now, id: id, deliveryStatus: .Sending, msgType: .Image, senderId: currentUserId, text: url.absoluteString) {
                                            try await chatInputBarviewModel.outgoingSocket.sent(.newMsg(msg))
                                        }
                                    }
                                } catch {
                                    Log(error)
                                }
                            case .failed(let error):
                                Log(error)
                            }
                        }
                    }
                    await MainActor.run {
                        chatInputBarviewModel.itemType = .text
                    }
                }
            }
            .padding()
        }
        
    }
}
