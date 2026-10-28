import OSLog
import TomiCore

/// Opens the store for a launch.
enum ProgressStoreOpener {
    private static let logger = Logger(category: .persistence)

    /// The store the launch options ask for. When it cannot be opened, or a test's known state cannot be
    /// written, the answer is the store that fails every call. It is never an empty store standing in for
    /// the real one: an empty store says the cook eats everything.
    static func store(for options: StoreLaunchOptions) -> any ProgressStore {
        do {
            let store = SwiftDataProgressStore(container: try .tomi(at: options.location))
            try prepare(store, for: options)
            return store
        } catch {
            logger.error("Saved data could not be opened: \(String(describing: error), privacy: .public)")
            return UnavailableProgressStore()
        }
    }

    private static func prepare(_ store: SwiftDataProgressStore, for options: StoreLaunchOptions) throws {
        if options.startsEmpty {
            try store.erase()
        }
        if options.seedsKnownState {
            try seed(store)
        }
    }

    private static func seed(_ store: SwiftDataProgressStore) throws {
        try store.erase()
        try KnownState().write(to: store)
    }
}
