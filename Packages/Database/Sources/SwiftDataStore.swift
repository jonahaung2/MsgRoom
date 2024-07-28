import SwiftUI
import SwiftData
import Models

public actor SwiftDataStore {
    nonisolated public lazy var container: ModelContainer = {
        let modelContainer: ModelContainer
        let configuration = ModelConfiguration(isStoredInMemoryOnly: false)
        do {
            modelContainer = try ModelContainer(for: PersistedRoom.self, PersistedContact.self, PersistedMsg.self, configurations: configuration)
        } catch {
            fatalError("Failed to create the model container: \(error)")
        }
        return modelContainer
    }()
    
    public init() {}
}
