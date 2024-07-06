import SwiftUI
import SwiftData

actor DataModel {
    static let shared = DataModel()
    private init() {}
    
    nonisolated lazy var container: ModelContainer = {
        let modelContainer: ModelContainer
        do {
            modelContainer = try ModelContainer(for: Room.self, Contact.self)
        } catch {
            fatalError("Failed to create the model container: \(error)")
        }
        return modelContainer
    }()
    
    lazy var actor: SwiftDataModelActor = {
        return SwiftDataModelActor(modelContainer: container)
    }()
}
