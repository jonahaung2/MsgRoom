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
import Models

struct ChatInputBarTextView: View {
    
    @EnvironmentObject private var chatInputBarviewModel: ChatInputBarViewModel
    @EnvironmentObject private var viewModel: RoomViewModel
    @FocusState private var textViewIsFocused
    @State private var showRadialBar = false
    let client = OpenAIClient()
    var body: some View {
        Group {
            HStack(alignment: .bottom, spacing: 5) {
                if chatInputBarviewModel.radialItemType == .text {
                    Menu.init {
                        Button {
                            didTapMenuButton(item: .camera)
                        } label: {
                            Label("Take Photo", systemSymbol: .camera)
                        }
                        Button {
                            didTapMenuButton(item: .file)
                        } label: {
                            Label("Browse Files", systemSymbol: .folder)
                        }
                        Button {
                            didTapMenuButton(item: .photo)
                        } label: {
                            Label("Photo Library", systemSymbol: .photo)
                        }

//                        AsyncButton(actionOptions: []) {
//                            if textViewIsFocused {
//                                MainActorQueue.shared.enqueue {
//                                    textViewIsFocused = false
//                                }
//                            }
//                            if !showRadialBar {
//                                showRadialBar = true
//                                return
//                            }
//                            didTapMenuButton(item: item)
//                        } label: {
//                            SystemImage(item.symbol, showRadialBar ? 26 : 20)
//                        }
//                        .tint(Color.adaptableColors[i].gradient)
                    } label: {
                        SystemImage(.photoOnRectangleAngled, 30)
                            .aspectRatio(1, contentMode: .fill)
                    }
                    TextField("Text..", text: $chatInputBarviewModel.text, axis: .vertical)
                        .focusable()
                        .focused($textViewIsFocused)
                        .focusEffectDisabled()
                        .multilineTextAlignment(.leading)
                        .lineLimit(1...10)
                        .keyboardType(.twitter)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.Shadow.main, in: RoundedRectangle(cornerRadius: 13, style: .circular))
//                        .padding(.leading, 50)
                    
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
                }
            }
            .contentTransition(.symbolEffect(.replace))
            .padding(.vertical, 4)
            .padding(.horizontal, 8)
            .background()
//            .overlay(alignment: .bottomLeading) {
//                ZStack {
//                    RadialLayout {
//                        ForEach(Array(ChatInputBarItem.allCases.enumerated()), id: \.offset) { (i, item) in
//                            switch item {
//                            case .video:
//                                VideoPickupButton(pickedVideo: $chatInputBarviewModel.videoAsset) { status in
//                                    switch status {
//                                    case .empty:
//                                        SystemImage(.videoFill, 30)
//                                    case .loading:
//                                        SystemImage(.videoCircle, 30)
//                                            .phaseAnimation([.rotate(.east), .rotate(.west)])
//                                    case .success(let item):
//                                        VideoPlayer(player: .init(playerItem: .init(asset: item)))
//                                            .scaledToFill()
//                                            .frame(square: 100)
//                                            .clipShape(Circle())
//                                    case .failure(_):
//                                        SystemImage(.boltCircleFill, 30)
//                                    }
//                                }
//                                .disabled(!showRadialBar)
//                            default:
//                                AsyncButton(actionOptions: []) {
//                                    if textViewIsFocused {
//                                        MainActorQueue.shared.enqueue {
//                                            textViewIsFocused = false
//                                        }
//                                    }
//                                    if !showRadialBar {
//                                        showRadialBar = true
//                                        return
//                                    }
//                                    didTapMenuButton(item: item)
//                                } label: {
//                                    SystemImage(item.symbol, showRadialBar ? 26 : 20)
//                                }
//                                .tint(Color.adaptableColors[i].gradient)
//                            }
//                        }
//                    }
//                    .zIndex(2)
//                    
//                    Button {
//                        chatInputBarviewModel.radialItemType = .text
//                        showRadialBar = false
//                    } label: {
//                        SystemImage(.power, 27)
//                    }.tint(.primary)
//                        .zIndex(showRadialBar ? 3 : 0)
//                }
//                .frame(square: showRadialBar && !textViewIsFocused ? 170 : 35)
//                .animation(.interactiveSpring(duration: 0.4, extraBounce: 0.4), value: showRadialBar && !textViewIsFocused )
//                .padding(.leading, 10)
//            }
        }
    }
    private func didTapMenuButton(item: ChatInputBarItem) {
        switch item {
        case .text:
            showRadialBar = false
            textViewIsFocused = true
        case .camera, .photo:
            chatInputBarviewModel.radialItemType = .photoPicker
        case .emoji:
            chatInputBarviewModel.radialItemType = .emojiPicker
        case .toggle:
            showRadialBar = false
            chatInputBarviewModel.radialItemType = .text
        case .video:
            break
        case .microphone:
            break
        case .file:
            break
        }
        MainActorQueue.shared.enqueue {
            showRadialBar = false
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
        if string.contains("?") {
            askAI(text: string)
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
                chatInputBarviewModel.radialItemType = .emojiPicker
                return
            }
            try await sendMessage()
        }
    }
    
    func askAI(text: String) {
        Task {
            let request = OpenAIClient.Prompt.ask(input: text)
            if let result = try? await client.request(request) {
                let text = result.trimmedText
                let msg = Msg(roomID: viewModel.datasource.room.id, senderID: viewModel.datasource.room.contacts.first?.id ?? "", msgKind: .Text, text: text)
                viewModel.interactor.sendAction(.init(item: .sendMsg(.msg(msg))))
            }
        }
        
    }
}
