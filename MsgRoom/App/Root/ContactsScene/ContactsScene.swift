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
import Models
import Services
import Core
import SFSafeSymbols

private extension PersistedContact {
    var firstCharacter: String {
        return String(name.first ?? .init(.empty))
    }
}
@MainActor
struct ContactsScene: View {
    
//    @Environment(\.modelContext) private var modelContext
//    @SectionedQuery(\.firstCharacter, sort: \.name, animation: .bouncy)
//    private var sections: SectionedResults<String, PersistedContact>
//    
    @State private var path: NavigationPath = .init()
    @Environment(\.editMode) private var editMode
    private let roomFinder = RoomFinderService()
    
    @State private var vm: ContactsViewModel = .init()
    @State private var selection: Set<Contact> = .init()
    var body: some View {
        
        NavigationStack(path: $path) {
            List(selection: $selection) {
                ForEach(vm.groups, id: \.0) { group in
                    let key = group.0
                    let contacts = group.1
                    Section(key) {
                        ForEach(contacts) { contact in
                            HStack(spacing: 20) {
                                TextAvatarView(text: contact.name)
                                    .frame(square: 30)
                                Text(contact.name)
                                    .fixedSize()
                                Color(uiColor: .systemBackground)
                                if selection.contains(contact) {
                                    Spacer()
                                    SystemImage(.checkmarkCircleFill)
                                        .foregroundStyle(.secondary)
                                        .symbolRenderingMode(.multicolor)
                                }
                            }
                            .swipeActions(edge: .trailing) {
                                Button {
                                    if selection.contains(contact) {
                                        selection.remove(contact)
                                    } else {
                                        selection.insert(contact)
                                    }
                                } label: {
                                    SystemImage(.bubbleLeftFill)
                                }
                            }
                            .onTapGesture {
                                Task {
                                    do {
                                        let room = try await roomFinder.getOrCreateRoomFor(for: contact)
                                        self.path.append(room)
                                    } catch {
                                        Log(error)
                                    }
                                }
                            }
                        }
                        .onDelete { index in
                            Task {
                                await index.concurrentForEach { i in
                                    if let model = group.1[safe: i] {
                                        await vm.delete(contact: model)
                                    }
                                }
                            }
                        }
                    }
                }
            }
//            List {
//                
//            }
            .navigationTitle("MsgRoom")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    EditButton()
                }
            }
            .taskOnce(id: vm.groups.isEmpty) { (oldValue, newValue) in
                if newValue {
                    await vm.fetch()
                    if await vm.groups.isEmpty {
                        await vm.syncContacts()
                    }
                }
            }
            .navigationDestination(for: Room.self) { room in
                RoomScene(DefaultMsgDatasource(room), MsgInteractionProvider(room))
            }
        }
    }
}
