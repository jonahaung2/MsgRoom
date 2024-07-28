//
//  EmojiPickerView.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 7/7/24.
//

import SwiftUI
import XUI
import EmojiKit

struct EmojiPickerView: View {
    
    private let items = zip(Emojis.enTypes, Emojis.values)
    private let rows = [
        GridItem(.fixed(50)),
        GridItem(.fixed(50)),
        GridItem(.fixed(50)),
        GridItem(.fixed(50))
    ]
    @EnvironmentObject private var chatInputBarviewModel: ChatInputBarViewModel
    @EnvironmentObject private var viewModel: RoomViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                AsyncButton {
                    chatInputBarviewModel.radialItemType = .text
                } label: {
                    SystemImage(.xmarkCircleFill)
                }
            }
            .padding(.horizontal)
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHGrid(rows: rows, alignment: .center) {
                    ForEach(Array(items), id: \.0) { title, emojis in
                        Section {
                            ForEach(emojis) { emoji in
                                AsyncButton {
                                    viewModel.interactor.sendAction(.init(item: .sendMsg(.emoji(emoji))))
                                } label: {
                                    ZStack {
                                        Text(emoji)
                                    }
                                    .frame(square: 40)
                                    .background(Color(uiColor: .systemBackground).gradient, in: Circle())
                                }
                            }
                        }
                    }
                }
                .font(.title)
                .frame(height: 250)
            }
        }
    }
}
