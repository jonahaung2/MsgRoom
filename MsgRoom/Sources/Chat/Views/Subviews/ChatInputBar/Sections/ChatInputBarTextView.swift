//
//  ChatInputBarTextView.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 26/6/24.
//

import SwiftUI
import XUI
import MsgRoomCore
import MediaPicker
import AVKit

struct ChatInputBarTextView<Msg: MsgRepresentable, Room: RoomRepresentable, Contact: ContactRepresentable>: View {
    
    @EnvironmentObject private var chatInputBarviewModel: ChatInputBarViewModel
    @EnvironmentObject private var viewModel: MsgRoomViewModel<Msg, Room, Contact>
    @FocusState private var textViewIsFocused
    
    var body: some View {
        HStack(alignment: .bottom) {
            if !textViewIsFocused {
                Group {
                    AsyncButton(actionOptions: []) {
                        if chatInputBarviewModel.itemType == .photoPicker {
                            chatInputBarviewModel.itemType = .text
                        } else {
                            if textViewIsFocused {
                                textViewIsFocused = false
                            } else {
                                chatInputBarviewModel.itemType = .photoPicker
                            }
                        }
                    } label: {
                        Group {
                            if chatInputBarviewModel.itemType == .photoPicker {
                                SystemImage(.xmarkCircleFill, 30)
                            } else {
                                SystemImage(textViewIsFocused ? .keyboardChevronCompactDown : .photoCircle, 30)
                                    .contentTransition(.symbolEffect(.replace))
                            }
                        }
                    }
                    .transition(.scale.animation(.interactiveSpring))
                    VideoPickupButton(pickedVideo: $chatInputBarviewModel.videoAsset) { status in
                        switch status {
                        case .empty:
                            SystemImage(.videoCircle, 30)
                        case .loading:
                            SystemImage(.videoCircle, 30)
                                .phaseAnimation([.rotate(.east), .rotate(.west)])
                        case .success(let item):
                            VideoPlayer(player: .init(playerItem: .init(asset: item)))
                                .scaledToFill()
                                .frame(square: 100)
                                .clipShape(Circle())
                        case .failure(_):
                            SystemImage(.boltCircleFill, 30)
                        }
                    }
                    .transition(.scale.animation(.interactiveSpring))
                }
                .fontWeight(.light)
            }
            ZStack {
                TextField("Text..", text: $chatInputBarviewModel.text, axis: .vertical)
                    .focused($textViewIsFocused)
                    .multilineTextAlignment(.leading)
                    .fontDesign(.rounded)
                    .lineLimit(1...10)
                    .keyboardType(.twitter)
            }.padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background {
                    RoundedRectangle(cornerRadius: 15, style: .continuous).stroke(.quaternary.opacity(1) , style: .init(lineWidth: 1), antialiased: true)
                }.highPriorityGesture(
                    TapGesture().onEnded({ _ in
                        textViewIsFocused = true
                    })
                )
            
            AsyncButton(actionOptions: []) {
                _Haptics.play(.soft)
                if chatInputBarviewModel.videoAsset != nil {
                    await MainActor.run {
                        chatInputBarviewModel.videoAsset = nil
                    }
                } else {
                    if !textViewIsFocused {
                        textViewIsFocused = true
                        return
                    }
                    try await sendMessage()
                }
            } label: {
                SystemImage(textViewIsFocused ? .chevronUpCircleFill : .pencilTipCropCircleBadgePlus, 35)
                    .rotationEffect(textViewIsFocused ? chatInputBarviewModel.text.isWhitespace ? .degrees(-90) : .degrees(0) : .degrees(0))
                    .animation(.smooth, value: chatInputBarviewModel.text.isWhitespace)
                    .contentTransition(.symbolEffect(.replace))
                    .symbolRenderingMode(.multicolor)
                    .fontWeight(.light)
            }
            .buttonStyle(.borderless)
            .padding(.horizontal, 5)
        }
        .padding(.horizontal, 10)
        .padding(.bottom, 4)
    }
    
    private func sendMessage() async throws {
        let text = chatInputBarviewModel.text
        if text.isWhitespace {
            self.chatInputBarviewModel.text = Lorem.random
            return
        }
        let string = text
        chatInputBarviewModel.text.removeAll()
        if let msg = try await Msg.create(conId: viewModel.datasource.room.id, date: .now, id: UUID().uuidString, deliveryStatus: .Sending, msgType: .Text, senderId: CurrentUser.current.id, text: string) {
            try await chatInputBarviewModel.outgoingSocket.sent(.newMsg(msg))
        }
    }
}
