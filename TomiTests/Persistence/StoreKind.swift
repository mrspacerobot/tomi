import TomiCore

@testable import Tomi

/// The two stores a screen can be handed. Both must behave the same through the protocol.
enum StoreKind: CaseIterable {
    case swiftData
    case inMemory

    @MainActor
    func emptyStore() throws -> any ProgressStore {
        switch self {
        case .swiftData: try StoreFixture().store
        case .inMemory: InMemoryProgressStore()
        }
    }

    /// An empty store with these cooks added, in this order.
    @MainActor
    func storeHolding(_ cooks: [CookEntry]) throws -> any ProgressStore {
        let store = try emptyStore()
        for cook in cooks {
            try store.add(cook)
        }
        return store
    }
}
