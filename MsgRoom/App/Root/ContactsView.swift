//
//  ContactsView.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 26/6/24.
//

import SwiftUI
import SwiftData
import URLImage
import XUI

struct ContactsView: View {
    
    @Injected(\.swiftDatabase) private var swiftDatabase
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Contact.id) private var contacts: [Contact]
    @State private var selection: Contact?
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(contacts) { contact in
                    Label {
                        Text(contact.name)
                            .badge(contact.phoneNumber)
                    } icon: {
                        URLImage(url: .init(string: contact.photoUrl), quality: .resized(100), scale: 1)
                            .aspectRatio(1, contentMode: .fill)
                            .frame(square: 30)
                            .clipShape(Circle())
                    }._tapToPush {
                        MsgRoomView<Message, Conversation>.init(viewModel: .init(makeConversation(contact)))
                    }
                    .swipeActions(edge: .leading) {
                        Button(role: .none) {
                            deleteItem(item: contact)
                        } label: {
                            Label("Hello", systemImage: "trash")
                        }
                    }
                }
                .onDelete(perform: { indexSet in
                    guard let first = indexSet.first else { return }
                    if contacts[first].persistentModelID == selection?.persistentModelID {
                        selection = nil
                    }
                    modelContext.delete(contacts[first])
                    try? modelContext.save()
                })
            }
            .buttonStyle(.plain)
            .overlay {
                if contacts.isEmpty {
                    ContentUnavailableView {
                        Label("No Trips", systemImage: "car.circle")
                    } description: {
                        Text("New trips you create will appear here.")
                    }
                }
            }
            .equatable(by: contacts.count)
            .animation(.bouncy, value: contacts)
            .navigationTitle("MsgRoom")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    EditButton()
                }
                ToolbarItem(placement: .topBarLeading) {
                    AsyncButton {
                        Task(priority: .background) {
                            let conversation = Contact(id: UUID().uuidString, name: Lorem.fullName, phoneNumber: Lorem.phoneNumber(), photoUrl: DemoImages.demoPhotosURLs.random()!.absoluteString, pushToken: Lorem.random)
                            await swiftDatabase.workshop.insert(conversation)
                            try await swiftDatabase.workshop.save()
                        }
                    } label: {
                        SystemImage(.plus)
                            .padding()
                    }
                }
            }
        }
    }
    private func makeConversation(_ contact: Contact) -> Conversation {
        let user = Contact.currentUser
        let id = user.id > contact.id ? contact.id + user.id : user.id + contact.id
        let item = Conversation.init(id: id, date: .now, name: contact.name, photoUrl: contact.photoUrl, type: .single)
        try? modelContext.save()
        return item
    }
    
    private func deleteItem(item: Contact) {
        if item.persistentModelID == selection?.persistentModelID {
            selection = nil
        }
        Task(priority: .utility) {
            await swiftDatabase.workshop.delete(item)
            try? await swiftDatabase.workshop.save()
        }
    }
    private func deleteTodo(indexSet: IndexSet) {
        if let index = indexSet.first {
            Task {
                let todo = contacts[index]
                await swiftDatabase.workshop.delete(todo)
                try? await swiftDatabase.workshop.save()
            }
            
        }
    }
}
