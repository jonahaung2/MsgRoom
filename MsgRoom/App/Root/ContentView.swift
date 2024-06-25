//
//  ContentView.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 12/3/24.
//

import SwiftUI
import XUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            List {
                ForEach(MockDataStore.shared.conversation(for: 22)) { con in
                    NavigationLink {
                        MsgRoomView<Message, Conversation>.init(viewModel: .init(con))
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
        }
    }
}
