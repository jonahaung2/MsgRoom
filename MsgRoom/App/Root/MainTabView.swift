//
//  MainTabView.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 26/6/24.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            ContentView()
                .tabItem {
                    Label("Home", systemSymbol: .house)
                }
            ContactsScene()
                .tabItem {
                    Label("Contacts", systemSymbol: .book)
                }
        }
    }
}
