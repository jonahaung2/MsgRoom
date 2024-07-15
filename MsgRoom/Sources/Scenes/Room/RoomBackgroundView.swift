//
//  SwiftUIView.swift
//  
//
//  Created by Aung Ko Min on 5/7/24.
//

import SwiftUI

struct RoomBackgroundView: View {
    enum Kind: Int, Hashable, CaseIterable {
        case `default`, plain, wallpaper_white
    }
    @AppStorage("RoomBackground") var backgroundKind = Kind.wallpaper_white
    
    var body: some View {
        switch backgroundKind {
        case .default:
            Color(uiColor: .systemBackground)
                .ignoresSafeArea()
        case .plain:
            Color.Shadow.main
                .ignoresSafeArea()
        case .wallpaper_white:
            Image("chatBg2")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        }
    }
}

