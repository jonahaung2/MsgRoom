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
            InboxSceneView()
                .tabItem {
                    Label("Home", systemSymbol: .house)
                }
            NavigationStack {
                ContactsScene()
            }
                .tabItem {
                    Label("Contacts", systemSymbol: .book)
                }
            
            RadialLayoutView()
                .tabItem {
                    Label("RadialLayoutView", systemSymbol: .book)
                }
        }
    }
}
