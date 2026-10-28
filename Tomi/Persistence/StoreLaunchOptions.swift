import Foundation

/// What the launch arguments say about saved data. UI tests pass them, a cook never does.
nonisolated struct StoreLaunchOptions: Equatable {
    /// Start with an empty store in memory.
    static let inMemoryArgument = "--store-in-memory"
    /// Keep the store in the UI tests' own file, so a test can relaunch the app and find what it left.
    static let uiTestFileArgument = "--store-ui-test-file"
    /// Start as if the store could not be opened.
    static let unavailableArgument = "--store-unavailable"
    /// Ask SwiftData for a file it cannot create, to test the real opening failure through the app.
    static let unwritableFileArgument = "--store-ui-test-unwritable-file"
    /// Empty the store and fill it with `KnownState`. Ignored for the cook's own store.
    static let seedKnownStateArgument = "--seed-known-state"
    /// Empty the store before the first screen, so a test starts as a new cook. Ignored for the cook's own store.
    static let startEmptyArgument = "--store-start-empty"
    /// UI tests can fail one cook save after the store has been prepared.
    static let failFirstCookSaveArgument = "--store-fail-first-cook-save"

    private static let testLocations: [(argument: String, location: StoreLocation)] = [
        (unavailableArgument, .unavailable),
        (unwritableFileArgument, .file(URL(filePath: "/dev/null/TomiUITests.store"))),
        (inMemoryArgument, .memory),
        (uiTestFileArgument, .uiTestFile),
    ]

    let location: StoreLocation
    let seedsKnownState: Bool
    let startsEmpty: Bool
    private(set) var failsFirstCookSave = false

    init(location: StoreLocation, seedsKnownState: Bool, startsEmpty: Bool = false) {
        self.location = location
        self.seedsKnownState = seedsKnownState && !location.isTheCooksOwn
        self.startsEmpty = startsEmpty && !location.isTheCooksOwn
    }

    init(arguments: [String]) {
        self.init(
            location: Self.location(in: arguments),
            seedsKnownState: arguments.contains(Self.seedKnownStateArgument),
            startsEmpty: arguments.contains(Self.startEmptyArgument)
        )
        failsFirstCookSave = arguments.contains(Self.failFirstCookSaveArgument) && !location.isTheCooksOwn
    }

    /// When several are given, the one that keeps the least wins.
    private static func location(in arguments: [String]) -> StoreLocation {
        for option in testLocations where arguments.contains(option.argument) {
            return option.location
        }
        return .phone
    }
}
