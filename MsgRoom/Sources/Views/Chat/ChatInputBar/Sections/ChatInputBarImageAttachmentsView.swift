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
            if !chatInputBarviewModel.imageAttachments.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack {
                        ForEach(chatInputBarviewModel.imageAttachments, id: \.id) { each in
                            ImageAttachmentViewerView(imageAttachment: each)
                                ._flexible(.vertical)
                                .clipShape(RoundedRectangle(cornerRadius: 5))
                                .overlay(alignment: .topTrailing) {
                                    AsyncButton(actionOptions: [.showProgressView]) {
                                        try await send(each)
                                    } label: {
                                        SystemImage(.arrowUpCircleFill, 50)
                                            .padding()
                                    }
                                }
                                .overlay(alignment: .bottomTrailing, content: {
                                    Button {
                                        removeImage(item: each)
                                    } label: {
                                        ZStack {
                                            Circle().fill(Color(uiColor: .systemBackground))
                                                .frame(width: 22, height: 22)
                                            SystemImage(.minusCircleFill, 18)
                                        }.padding(3)
                                    }
                                })
                               
                        }
                    }
                    .padding(.horizontal)
                    .symbolRenderingMode(.multicolor)
                }
                .frame(maxHeight: 220)
                .transition(.scale)
            } else {
                Color(uiColor: .systemBackground)
                    .frame(height: 20)
                    .onAppear {
                        chatInputBarviewModel.itemType = .text
                    }
            }
        }
        .animation(.interactiveSpring(duration: 0.3, extraBounce: 0.2), value: chatInputBarviewModel.imageAttachments.count)
    }
    
    private func send(_ item: ImageAttachment) async throws {
        if let status = item.imageStatus {
            switch status {
            case .loading:
                break
            case .finished(let image):
                let uIImage = image
                do {
                    let id = UUID().uuidString
                    if let url = try await uIImage.temporaryLocalFileUrl(id: id, quality: 0.5) {
                        if let msg = try await Msg.create(conId: viewModel.datasource.room.id, date: .now, id: id, deliveryStatus: .Sending, msgType: .Image, senderId: CurrentUser.current.id, text: url.absoluteString) {
                            try await chatInputBarviewModel.outgoingSocket.sent(.newMsg(msg))
                            removeImage(item: item)
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
    
    private func removeImage(item: ImageAttachment) {
        if let i = chatInputBarviewModel.imageAttachments.firstIndex(where: { item in
            item.id == item.id
        }) {
            chatInputBarviewModel.imageAttachments.remove(at: i)
        }
    }
}
