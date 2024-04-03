//
//  ContentView.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 12/3/24.
//

import SwiftUI
import XUI

struct ContentView: View {
    let vm = MsgRoomViewModel<Msg, Con>(con: Con(id: "2", bgImage_: 1, bubbleCornorRadius: 16, date: .now, name: "Jonah AUng", photoUrl: "ll", themeColor_: 0, members: Contact.mocks()))
    var body: some View {
        NavigationStack {
            VStack {
                NavigationLink("Start") {
                    MsgRoomView<Msg, Con>()
                        .environmentObject(vm)
                }
            }
            .navigationTitle("MsgRoom")
        }
    }
}

extension Contact {
    
    static func mocks() -> [Contact] {
        var values = [Contact]()
        values.append(CurrentUser.contact)
        (0...0).forEach { each in
            let msg = Contact(id: each.description, name: Lorem.fullName, phoneNumber: Lorem.emailAddress, photoUrl: "https://avatars.githubusercontent.com/u/108913030?v=4", pushToken: Lorem.random)
            values.append(msg)
        }
        return values
    }
}
