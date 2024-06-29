//
//  ContactsView.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 26/6/24.
//

import SwiftUI
import URLImage
import XUI
import SwiftData

private extension Contact {
    var firstCharacter: String {
        return String(name.first ?? .init(.empty))
    }
}

struct ContactsScene: View {
    
    @Environment(\.modelContext) private var modelContext
    @SectionedQuery(\.firstCharacter, sort: \.name, animation: .snappy)
    private var sections: SectionedResults<String, Contact>
    
    @State private var viewModel = ContactSceneViewModel()
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(sections) { section in
                    Section(section.id) {
                        ForEach(section.elements) { contact in
                            HStack(spacing: 20) {
                                URLImage(url: .init(string: contact.photoURL), quality: .resized(100)) { image in
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .clipShape(Circle())
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(square: 30)
                                
                                Text(contact.name)
                                Spacer()
                                Text(contact.mobile)
                                    .font(.subheadline)
                                    .foregroundStyle(.tertiary)
                            }
                            .padding(.vertical, 2)
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button(role: .destructive) {
                                    modelContext.delete(contact)
                                } label: {
                                    Label("Delete", systemImage: "trash.fill")
                                }
                            }
                            ._tapToPush {
                                MsgRoomView<Msg, Room, Contact>(viewModel: .init(makeRoom(contact)!))
                            }
                        }
                    }
                }
            }
            .navigationTitle("MsgRoom")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    EditButton()
                }
            }
            .taskOnce(id: sections.isEmpty) { old, new in
                if new {
                    do {
                        try await PhoneContacts.fetchContacts().concurrentForEach { cnContact in
                            if let contact = Contact(cnContact: cnContact) {
                                await viewModel.insert(contact)
                            }
                        }
                    } catch {
                        Log(error)
                    }
                }
            }
        }
    }
    private func makeRoom(_ contact: Contact) -> Room? {
        let id = currentUserId > contact.id ? contact.id + currentUserId : currentUserId + contact.id
        
        let existing = try? modelContext.fetch(.init(predicate: #Predicate<Room>{ model in
            model.id == id
        })).first
        if let existing {
            return existing
        }
        let item = Room(id: id, name: contact.name, type: .single, createdDate: .now, photoURL: contact.photoURL)
        modelContext.insert(item)
        contact.room = item
        return item
    }
}
public extension Sequence {
    func concurrentForEach(
        _ operation: @escaping (Element) async -> Void
    ) async {
        await withTaskGroup(of: Void.self) { group in
            for element in self {
                group.addTask {
                    await operation(element)
                }
            }
        }
    }
}
