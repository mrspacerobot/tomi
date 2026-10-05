import Foundation

/// Where saved data lives for this launch.
nonisolated enum StoreLocation: Equatable {
    /// The cook's own store on the phone.
    case phone
    /// A file of its own that UI tests fill and read back across launches. Never the cook's store.
    case uiTestFile
    /// Nowhere: an empty store that is gone when the app closes.
    case memory
    /// A store that fails to open, for the tests of what the cook sees then.
    case unavailable
    /// A file a unit test chose.
    case file(URL)

    /// Only a store that is not the cook's own may be emptied and filled by a test.
    var isTheCooksOwn: Bool {
        self == .phone
    }
}
