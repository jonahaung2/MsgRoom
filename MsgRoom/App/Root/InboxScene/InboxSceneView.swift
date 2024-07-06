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

struct InboxSceneView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Query(animation: .snappy) private var rooms: [Room]
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(rooms) { con in
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
                            if let lastMsg = con.lastMsg {
                                Text(lastMsg.text)
                                    .font(.callout)
                                    .foregroundStyle(.secondary)
                                
                                +
                                Text(lastMsg.senderName)
                                    .font(.footnote)
                                    .foregroundStyle(.quaternary)
                            }
                        }
                        Spacer()
                    }
                    ._tapToPush {
                        MsgRoomView<Msg, Room, Contact>.init(room: con)
                    }
                    .buttonStyle(.plain)
                }
                .onDelete(perform: { indexSet in
                   
                   
                })
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("MsgRoom")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    AsyncButton {
//                        if let conversation = try await Room.create(id: UUID().uuidString, date: .now, name: Lorem.fullName, photoUrl: DemoImages.demoPhotosURLs.random()!.absoluteString, type: .single) {
//                            self.rooms.append(conversation as! Room)
//                        }
                        
                    } label: {
                        SystemImage(.plus)
                            .padding()
                    }
                }
            }
        }
    }
}
