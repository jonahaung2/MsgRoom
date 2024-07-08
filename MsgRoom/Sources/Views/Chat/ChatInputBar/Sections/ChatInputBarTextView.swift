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
import AsyncQueue

struct ChatInputBarTextView<Msg: MsgRepresentable, Room: RoomRepresentable, Contact: ContactRepresentable>: View {
    
    @EnvironmentObject private var chatInputBarviewModel: ChatInputBarViewModel
    @EnvironmentObject private var viewModel: MsgRoomViewModel<Msg, Room, Contact>
    @FocusState private var textViewIsFocused
    @State private var showToolBar = false
    var body: some View {
        Group {
            HStack(alignment: .bottom, spacing: 5) {
                if chatInputBarviewModel.itemType == .text {
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
                    .background(RoundedRectangle(cornerRadius: 13).fill(Color.Shadow.main))
                    .padding(.leading, 50)
                    
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
                    .padding(.horizontal, 5)
                    .animation(.snappy, value: chatInputBarviewModel.text.isEmpty)
                    .phaseAnimation([.scale([0.9, 0.8, 0.9].random()!), .scale(1)], showToolBar.description)
                }
            }
            .contentTransition(.symbolEffect(.replace))
            .padding(.vertical, 4)
            .padding(.horizontal, 8)
            ._flexible(.horizontal)
            .background(.bar)
            .overlay(alignment: .bottomLeading) {
                ZStack {
                    RadialLayout {
                        ForEach(Array(ChatInputBarItem.allCases.enumerated()), id: \.offset) { (i, item) in
                            switch item {
                            case .video:
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
                                .disabled(!showToolBar)
                            default:
                                AsyncButton(actionOptions: []) {
                                    if textViewIsFocused {
                                        MainActorQueue.shared.enqueue {
                                            textViewIsFocused = false
                                        }
                                    }
                                    if !showToolBar {
                                        showToolBar = true
                                        return
                                    }
                                    didTapMenuButton(item: item)
                                } label: {
                                    SystemImage(item.symbol, showToolBar ? 26 : 20)
                                }
                                .tint(Color.adaptableColors[i].gradient)
                            }
                        }
                    }
                    .zIndex(2)
                    
                    Button {
                        chatInputBarviewModel.itemType = .text
                        showToolBar = false
                    } label: {
                        SystemImage(.power, 27)
                    }.tint(.primary)
                        .zIndex(showToolBar ? 3 : 0)
                }
                .frame(square: showToolBar && !textViewIsFocused ? 170 : 35)
                .animation(.interactiveSpring(duration: 0.4, extraBounce: 0.4), value: showToolBar && !textViewIsFocused )
                .padding(.leading, 10)
            }
        }
    }
    private func didTapMenuButton(item: ChatInputBarItem) {
        switch item {
        case .text:
            showToolBar = false
        case .camera, .photo:
            chatInputBarviewModel.itemType = .photoPicker
        case .emoji:
            chatInputBarviewModel.itemType = .emojiPicker
        case .toggle:
            showToolBar = false
            chatInputBarviewModel.itemType = .text
        case .video:
            break
        case .microphone:
            break
        case .file:
            break
        }
        MainActorQueue.shared.enqueue {
            showToolBar = false
        }
    }
    private func sendMessage() async throws {
        
        let text = chatInputBarviewModel.text
        if text.isWhitespace {
            self.chatInputBarviewModel.text = Lorem.random
            return
        }
        let string = text
        chatInputBarviewModel.text.removeAll()
        viewModel.interactor.sendAction(.init(item: .sendMsg(.text(string))))
    }
    private func sendButtonPressed() async throws {
        _Haptics.play(.soft)
        if chatInputBarviewModel.videoAsset != nil {
            await MainActor.run {
                chatInputBarviewModel.videoAsset = nil
            }
        } else {
            if !textViewIsFocused {
                chatInputBarviewModel.itemType = .emojiPicker
                return
            }
            try await sendMessage()
        }
    }
}
