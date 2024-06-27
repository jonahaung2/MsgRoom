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
    
    @State private var conversations = [Conversation]()
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(conversations) { con in
                    HStack {
                        URLImage(url: .init(string: con.photoURL ?? ""), quality: .resized(100)) { image in
                            CircleImage(image: image.resizable())
                        } placeholder: {
                            ProgressView()
                        }
                        .scaledToFill()
                        .frame(square: 60)
                        VStack(alignment: .leading) {
                            Text(con.name).bold()
//                            Text(Array<Message>(con.msgs()).first!.text)
//                                .font(.callout)
//                                .foregroundStyle(.secondary)
                        }
                        
                        Spacer()
                    }
                    ._tapToPush {
                        MsgRoomView<Msg, Conversation>.init(viewModel: .init(con))
                    }
                    .buttonStyle(.plain)
                }
                .onDelete(perform: { indexSet in
                   
                   
                })
            }
            .animation(.bouncy, value: conversations)
            .navigationTitle("MsgRoom")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    AsyncButton {
                        if let conversation = try await Conversation.create(id: UUID().uuidString, date: .now, name: Lorem.fullName, photoUrl: DemoImages.demoPhotosURLs.random()!.absoluteString, type: .single) {
                            self.conversations.append(conversation as! Conversation)
                        }
                        
                    } label: {
                        SystemImage(.plus)
                            .padding()
                    }
                }
            }
        }
    }
}
