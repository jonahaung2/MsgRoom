import SwiftUI
import SwiftData

actor SwiftDataStore {
    static let shared = SwiftDataStore()
    private init() {}
    
    nonisolated lazy var container: ModelContainer = {
        let modelContainer: ModelContainer
        let configuration = ModelConfiguration(isStoredInMemoryOnly: false)
        do {
            modelContainer = try ModelContainer(for: PersistedRoom.self, PersistedContact.self, MsgData.self, configurations: configuration)
        } catch {
            fatalError("Failed to create the model container: \(error)")
        }
        return modelContainer
    }()
    lazy var actor: SwiftDataModelActor = {
        return SwiftDataModelActor(modelContainer: container)
    }()
}
