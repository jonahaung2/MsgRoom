//
//  ContentView.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 12/3/24.
//

import SwiftUI
import XUI
import SwiftData
import URLImage

struct ContentView: View {
    
    
//    @State var conversations: [Conversation] = []
    @Injected(\.swiftDatabase) private var swiftDatabase
    
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Conversation.name) private var conversations: [Conversation]
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(conversations) { con in
                    HStack {
                        URLImage(url: .init(string: con.photoUrl), quality: .resized(100), scale: 1)
                            .aspectRatio(1, contentMode: .fill)
                            .frame(square: 60)
                            .clipShape(Circle())
                        
                        VStack(alignment: .leading) {
                            Text(con.name).bold()
                            Text(Array<Message>(con.msgs()).first!.text)
                                .font(.callout)
                                .foregroundStyle(.secondary)
                        }
                        
                        Spacer()
                    }
                    ._tapToPush {
                        MsgRoomView<Message, Conversation>.init(viewModel: .init(con))
                    }
                    .buttonStyle(.plain)
                }
                .onDelete(perform: { indexSet in
                    guard let first = indexSet.first else { return }
                    modelContext.delete(conversations[first])
                    try? modelContext.save()
                })
            }
            .animation(.bouncy, value: conversations)
            .navigationTitle("MsgRoom")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    AsyncButton {
                        let conversation = Conversation(id: UUID().uuidString, date: .now, name: Lorem.fullName, photoUrl: DemoImages.demoPhotosURLs.random()!.absoluteString, type: .single)
                        await swiftDatabase.workshop.insert(conversation)
                        try await swiftDatabase.workshop.save()
                    } label: {
                        SystemImage(.plus)
                            .padding()
                    }
                }
            }
        }
    }
}
