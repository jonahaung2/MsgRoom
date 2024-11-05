import SwiftData
import Models

public actor ChatDataContainer {
    nonisolated lazy var container: ModelContainer = {
        let modelContainer: ModelContainer
        let configuration = ModelConfiguration(isStoredInMemoryOnly: false, groupContainer: .identifier("group.com.jonahaung.msgRoom"))
        do {
            modelContainer = try ModelContainer(for: PConversation.self, PContact.self, PMsg.self, configurations: configuration)
        } catch {
            fatalError("Failed to create the model container: \(error)")
        }
        return modelContainer
    }()
    
    init() {}
}
