//
//  ContentView.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 12/3/24.
//

import SwiftUI
import XUI
import SwiftData
import ImageLoaderUI
import Models

struct InboxSceneView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Query(animation: .snappy) private var rooms: [PersistedRoom]
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(rooms) { con in
                    HStack {
                        LazyImage(url: .init(string: con.photoURL ?? ""))
                            .scaledToFill()
                            .frame(square: 60)
                            .clipShape(Circle())
                        
                                  VStack(alignment: .leading) {
                            Text(con.name).bold()
                            if let lastMsg = con.lastMsg {
                                Text(lastMsg.senderName)
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
                                let room = Room(persisted: con)
                                RoomScene(
                                    DefaultMsgDatasource(room),
                                    MsgInteractionProvider(room)
                                )
                            }
                            .buttonStyle(.plain)
                                  }
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
