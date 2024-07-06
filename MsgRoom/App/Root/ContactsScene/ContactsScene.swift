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
    @Injected(\.swiftDatabase) private var swiftDatabase
    @State private var viewModel = ContactSceneViewModel()
    @State private var path: NavigationPath = .init()
    private let roomFinder = RoomFinder<Msg, Room, Contact>()
    
    var body: some View {
        NavigationStack(path: $path) {
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
                            .equatable(by: contact)
                            .onTapGesture {
                                Task { @MainActor in
                                    do {
                                        let room = try await roomFinder.getOrCreateRoomFor(for: contact, context: modelContext)
                                        self.path.append(room)
                                    } catch {
                                        Log(error)
                                    }
                                }
                            }
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                AsyncButton {
                                    let room = try await roomFinder.getOrCreateRoomFor(for: contact, context: modelContext)
                                    self.path.append(room)
                                } label: {
                                    Label("Chat", systemImage: "bubble.fill")
                                }
                                Button(role: .destructive) {
                                    modelContext.delete(contact)
                                } label: {
                                    Label("Delete", systemImage: "trash.fill")
                                }
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
                                await swiftDatabase.actor.insert(contact)
                            }
                        }
                        try await swiftDatabase.actor.save()
                    } catch {
                        Log(error)
                    }
                }
            }
            .navigationDestination(for: Room.self) { room in
                MsgRoomView<Msg, Room, Contact>(room: room)
            }
        }
    }
}
