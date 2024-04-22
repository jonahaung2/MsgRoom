//
//  ContentView.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 12/3/24.
//

import SwiftUI
import XUI
import FireAuth
import MediaPicker
import FirebaseAuth

struct ContentView: View {
    var body: some View {
        NavigationStack {
            List {
                ForEach(MockDataStore.shared.conversation(for: 22)) { con in
                    NavigationLink {
                        MsgRoomView<Message>(viewModel: .init(datasource: .init(con)))
                    } label: {
                        VStack(alignment: .leading) {
                            Text(con.name).bold()
                            Text(Array<Message>(con.msgs()).first!.text)
                                .font(.callout)
                                .foregroundStyle(.secondary)
                        }
                        ._flexible(.vertical)
                    }
                }
            }
            .navigationTitle("MsgRoom")
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Text("Log in")
                        ._presentSheet {
                            NavigationStack {
                                SignInWithPhoneNumberView()
                            }
                        }
                    Text("Email")
                        ._presentSheet {
                            NavigationStack {
                                SignInWithEmailPassswordView()
                            }
                        }
                }
                ToolbarItem(placement: .topBarLeading) {
                    AsyncButton {
                        try Auth.auth().signOut()
                    } label: {
                        Text("Sign Out")
                    }
                }
            }
        }
    }
}
