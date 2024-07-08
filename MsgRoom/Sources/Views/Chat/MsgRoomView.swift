//
//  MsgRoomView.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 12/3/24.
//

import SwiftUI
import XUI

public struct MsgRoomView<Msg: MsgRepresentable, Room: RoomRepresentable, Contact: ContactRepresentable>: View {
    
    @StateObject private var viewModel: MsgRoomViewModel<Msg, Room, Contact>
    @Environment(\.dismiss) private var dismiss
    @State private var colorData = ColorData.white
    
    public init(_ dataProvider: MsgDatasourceProviding, _ interation: MsgInteractionProviding) {
        self._viewModel = .init(wrappedValue: .init(dataProvider, interation))
    }
    public var body: some View {
        ChatScrollView<Msg, Room, Contact>()
            .ignoresSafeArea(edges: .top)
            .safeAreaInset(edge: .top) {
                ChatTopBar<Msg, Room, Contact>()
            }
            .overlay(alignment: .bottom) {
                VStack(spacing: 4) {
                    ScrollDownButton<Msg, Room, Contact>()
                        .animation(.smooth, value: viewModel.showScrollToLatestButton)
                }
            }
            .safeAreaInset(edge: .bottom, content: {
                ChatInputBar<Msg, Room, Contact>()
            })
            .environmentObject(viewModel)
            .toolbar(.hidden, for: .tabBar)
            .toolbar(.hidden, for: .navigationBar)
            .background(RoomBackground())
    }
}
