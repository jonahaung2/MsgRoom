//
//  ContactsView.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 26/6/24.
//

import SwiftUI
import XUI
import SwiftData
import UI

private extension PersistedContact {
    var firstCharacter: String {
        return String(name.first ?? .init(.empty))
    }
}

struct ContactsScene: View {
    
    @Environment(\.modelContext) private var modelContext
    @SectionedQuery(\.firstCharacter, sort: \.name, animation: .snappy)
    private var sections: SectionedResults<String, PersistedContact>
    @Injected(\.swiftdataRepo) private var swiftdataRepo
    
    @State private var viewModel = ContactSceneViewModel()
    @State private var path: NavigationPath = .init()
    private let roomFinder = RoomFinder()
    
    var body: some View {
        NavigationStack(path: $path) {
            List {
                ForEach(sections) { section in
                    Section(section.id) {
                        ForEach(section.elements) { contact in
                            HStack(spacing: 20) {
                                LazyImage(url: .init(string: contact.photoURL))
                                    .scaledToFill()
                                    .frame(square: 30)
                                    .clipShape(Circle())
                                Text(contact.name)
                                Spacer()
                                Text(contact.mobile)
                                    .font(.subheadline)
                                    .foregroundStyle(.tertiary)
                            }
                            .padding(.vertical, 2)
                            .equatable(by: contact)
                            .onTapGesture {
                                Task {
                                    do {
                                        let room = try await roomFinder.getOrCreateRoomFor(for: contact, context: modelContext)
                                        self.path.append(room)
                                    } catch {
                                        Log(error)
                                    }
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
                                switch await swiftdataRepo.create(contact) {
                                case .success(let model):
                                    break
                                case .failure(let error):
                                    break
                                }
                            }
                        }
                    } catch {
                        Log(error)
                    }
                }
            }
            .navigationDestination(for: Room.self) { room in
                RoomScene(MsgDatasourceProvider(room), MsgInteractionProvider(room))
            }
        }
    }
}
