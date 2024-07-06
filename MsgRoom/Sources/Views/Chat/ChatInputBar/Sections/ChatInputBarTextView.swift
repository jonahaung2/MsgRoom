//
//  ChatInputBarTextView.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 26/6/24.
//

import SwiftUI
import XUI
import MediaPicker
import AVKit
import SFSafeSymbols

struct ChatInputBarTextView<Msg: MsgRepresentable, Room: RoomRepresentable, Contact: ContactRepresentable>: View {
    
    @EnvironmentObject private var chatInputBarviewModel: ChatInputBarViewModel
    @EnvironmentObject private var viewModel: MsgRoomViewModel<Msg, Room, Contact>
    @FocusState private var textViewIsFocused
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 5) {
            if !textViewIsFocused {
                Group {
                    VideoPickupButton(pickedVideo: $chatInputBarviewModel.videoAsset) { status in
                        switch status {
                        case .empty:
                            SystemImage(.videoFill, 30)
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
                    
                    AsyncButton {
                        
                    } label: {
                        SystemImage(.micFill, 30)
                    }
                    
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
                                SystemImage(textViewIsFocused ? .keyboardChevronCompactDown : .photoFillOnRectangleFill, 30)
                                   
                            }
                        }
                    }
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
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(RoundedRectangle(cornerSize: CGSize(width: 15, height: 15)).stroke(Color(uiColor: .opaqueSeparator), lineWidth: 1))
            .compositingGroup()
            
            AsyncButton(actionOptions: []) {
                try await sendButtonPressed()
            } label: {
                Group {
                    if textViewIsFocused {
                        SystemImage(textViewIsFocused ? .chevronUpCircleFill : .quoteClosing, 35)
                            .rotationEffect(textViewIsFocused ? chatInputBarviewModel.text.isWhitespace ? .degrees(-90) : .degrees(0) : .degrees(0))
                    } else {
                        Text("😍").font(.title)
                    }
                }
            }
        }
        .contentTransition(.symbolEffect(.replace))
        .padding(.bottom, 4)
        .padding(.horizontal, 8)
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
    private func sendButtonPressed() async throws {
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
    }
}
