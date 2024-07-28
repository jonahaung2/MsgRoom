//
//  MsgRoomView.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 12/3/24.
//

import SwiftUI
import XUI
import Models
import Database
import Core

public struct RoomScene: View {
    
    @StateObject private var viewModel: RoomViewModel
    @Environment(\.dismiss) private var dismiss
    
    init(
        _ dataProvider: any MsgDatasource,
        _ interation: MsgInteractions
    ) {
        self._viewModel = .init(wrappedValue: .init(dataProvider, interation))

    }
    
    public var body: some View {
        RoomScrollView()
            .ignoresSafeArea(edges: .top) 
            .safeAreaInset(edge: .top) {
                RoomTopBarView()
            }
            .overlay(alignment: .bottom) {
                VStack(spacing: 4) {
                    RoomScrollDownButton()
                        .animation(.smooth, value: viewModel.roomState.showScrollToLatestButton)
                }
            }
            .safeAreaInset(edge: .bottom) {
                RoomBottomBarView()
            }
            .environmentObject(viewModel)
            .toolbar(.hidden, for: .tabBar)
            .toolbar(.hidden, for: .navigationBar)
            .background(RoomBackgroundView())
    }
}
