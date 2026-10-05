import OSLog
import TomiCore

/// Opens the store for a launch.
enum ProgressStoreOpener {
    private static let logger = Logger(category: .persistence)

    /// The store the launch options ask for. When it cannot be opened, or a test's known state cannot be
    /// written, the answer is the store that fails every call. It is never an empty store standing in for
    /// the real one: an empty store says the cook eats everything.
    static func store(for options: StoreLaunchOptions, catalog: SkillCatalog?) -> any ProgressStore {
        do {
            let store = SwiftDataProgressStore(container: try .tomi(at: options.location))
            if options.seedsKnownState {
                try seed(store, catalog: catalog)
            }
            return store
        } catch {
            logger.error("Saved data could not be opened: \(String(describing: error), privacy: .public)")
            return UnavailableProgressStore()
        }
    }

    private static func seed(_ store: SwiftDataProgressStore, catalog: SkillCatalog?) throws {
        guard let catalog else {
            throw ProgressStoreError.unavailable
        }
        try store.erase()
        try KnownState(catalog: catalog).write(to: store)
    }
}
