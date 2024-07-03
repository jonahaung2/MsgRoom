//
//  MsgRoomView.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 12/3/24.
//

import SwiftUI
import XUI
import SwiftData

public struct MsgRoomView<Msg: MsgRepresentable, Room: RoomRepresentable, Contact: ContactRepresentable>: View {
    
    @StateObject private var viewModel: MsgRoomViewModel<Msg, Room, Contact>
    @Injected(\.incomingSocket) private var incomingSocket
    @Environment(\.dismiss) private var dismiss
    @State private var bottomHeight = CGFloat(0)
    public init(room: Room) {
        self._viewModel = .init(wrappedValue: .init(room))
    }
    public var body: some View {
        ChatScrollView<Msg, Room, Contact>()
            .safeAreaInset(edge: .top) {
                ChatTopBar<Msg, Room, Contact>()
            }
            .overlay(alignment: .bottom) {
                ScrollDownButton<Msg, Room, Contact>()
                    .animation(.snappy, value: viewModel.showScrollToLatestButton)
                    .frame(height: max(0, bottomHeight-10))
            }
            .safeAreaInset(edge: .bottom) {
                VStack {
                    ChatInputBar<Msg, Room, Contact>()
                        .background {
                            GeometryReader { geo in
                                let height = geo.size.height
                                Color.blue
                                    .task(id: geo.size.height.isZero, debounceTime: .seconds(0.2)) {
                                        DispatchQueue.main.async {
                                            bottomHeight = height
                                        }
                                    }
                                
                            }
                        }
                }
            }
            .environmentObject(viewModel)
            .toolbar(.hidden, for: .tabBar)
            .toolbar(.hidden, for: .navigationBar)
    }
}
