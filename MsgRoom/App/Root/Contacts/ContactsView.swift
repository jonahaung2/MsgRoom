//
//  ContactsView.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 26/6/24.
//

import SwiftUI
import URLImage
import XUI

struct ContactsView: View {
    
    @Injected(\.contacts) private var contacts
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(contacts.contacts) { contact in
                    HStack {
                        URLImage(url: .init(string: contact.photoURL.str), quality: .resized(100)) { image in
                            image
                                .resizable()
                                .scaledToFill()
                                .clipShape(Circle())
                        } placeholder: {
                            ProgressView()
                        }
                        .scaledToFill()
                        .frame(square: 30)
                        .padding(.vertical, 3)
                        .padding(.trailing, 8)
                        
                        Text(contact.name.str)
                        Spacer()
                        Text(contact.mobile.str)
                            .font(.subheadline)
                            .foregroundStyle(.tertiary)
                    }
//                    ._tapToPush {
//                        MsgRoomView<Msg, Conversation>.init(viewModel: .init(makeConversation(contact)))
//                    }
                    .swipeActions(edge: .leading) {
                        AsyncButton {
                            await deleteItem(item: contact)
                        } label: {
                            Label("Hello", systemImage: "trash")
                        }
                    }
                }
                .onDelete(perform: { indexSet in
                   
                    
                })
            }
            .navigationTitle("MsgRoom")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    EditButton()
                }
                ToolbarItem(placement: .topBarLeading) {
                    AsyncButton {
//                        let conversation = Contact(id: UUID().uuidString, name: Lorem.fullName, phoneNumber: Lorem.phoneNumber(), photoUrl: DemoImages.demoPhotosURLs.random()!.absoluteString, pushToken: Lorem.random)
                        
                    } label: {
                        SystemImage(.plus)
                            .padding()
                    }
                }
            }
        }
    }
    private func makeConversation(_ contact: Contact) async -> Conversation {
    
        let id = currentUserId > contact.id ? contact.id + currentUserId : currentUserId + contact.id
        let item = try? await Conversation.create(id: id, date: .now, name: contact.name ?? "", photoUrl: contact.photoURL ?? "", type: .single)
        return item as! Conversation
    }
    
    @MainActor private func deleteItem(item: Contact) async {
    }
}
