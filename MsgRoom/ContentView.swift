//
//  ContentView.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 12/3/24.
//

import SwiftUI
import XUI

struct ContentView: View {
    let vm = MsgRoomViewModel<Msg>(_con: Con(id: "2", bgImage_: 1, bubbleCornorRadius: 16, date: .now, name: "Jonah AUng", photoUrl: "ll", themeColor_: 0, members_: [Lorem.emailAddress]))
    var body: some View {
        NavigationStack {
            VStack {
                NavigationLink("Start") {
                    MsgRoomView<Msg>()
                        .environmentObject(vm)
                }
            }
            .navigationTitle("MsgRoom")
        }
    }
}

#Preview {
    ContentView()
}
