//
//  EmojiPickerView.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 7/7/24.
//

import SwiftUI
import XUI

struct EmojiPickerView: View {
    
    private let items = zip(Emojis.enTypes, Emojis.values)
    private let rows = [
        GridItem(.fixed(50)),
        GridItem(.fixed(50)),
        GridItem(.fixed(50)),
        GridItem(.fixed(50))
    ]
    @EnvironmentObject private var chatInputBarviewModel: ChatInputBarViewModel
    @EnvironmentObject private var viewModel: MsgRoomViewModel<Msg, Room, Contact>
    
    var body: some View {
        
        VStack {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHGrid(rows: rows, alignment: .center) {
                    ForEach(Array(items), id: \.0) { title, emojis in
                        Section {
                            ForEach(emojis) { emoji in
                                AsyncButton {
                                    chatInputBarviewModel.text = emoji
                                    chatInputBarviewModel.itemType = .text
                                } label: {
                                    ZStack {
                                        Text(emoji)
                                    }
                                    .frame(square: 40)
                                }
                                .scrollTransition { effect, phase in
                                    effect.blur(radius: phase.value, opaque: false)
                                }
                            }
                        }
                    }
                }
                .font(.title)
                .frame(height: 250)
            }
            .transition(
                .move(edge: .top)
                .combined(with: .opacity)
                .animation(.interpolatingSpring)
            )
            HStack {
                Spacer()
                AsyncButton {
                    chatInputBarviewModel.itemType = .text
                } label: {
                    SystemImage(.xmarkCircleFill, 25)
                }
            }.padding(.horizontal)
        }
    }
}
