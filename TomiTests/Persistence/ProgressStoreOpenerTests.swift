import Foundation
import Testing
import TomiCore

@testable import Tomi

/// Opening the store for a launch. A store that cannot be opened must never look like an empty one.
@MainActor
@Suite struct ProgressStoreOpenerTests {
    let catalog = BundledLibrary.catalog()

    @Test func anInMemoryStoreStartsEmpty() throws {
        let store = open(["--store-in-memory"])
        #expect(try store.profile() == CookProfile())
        #expect(try store.cookLog().isEmpty)
    }

    @Test func aSeededStoreHoldsTheKnownState() throws {
        let known = KnownState(catalog: try #require(catalog))
        let store = open(["--store-in-memory", "--seed-known-state"])
        #expect(try store.profile() == known.profile)
        #expect(try store.cookLog().map(\.lesson) == known.cookLog.map(\.lesson))
    }

    @Test func aStoreThatCannotBeOpenedFailsEveryReadInsteadOfGivingDefaults() {
        let store = open(["--store-unavailable"])
        #expect(throws: ProgressStoreError.unavailable) { try store.profile() }
        #expect(throws: ProgressStoreError.unavailable) { try store.cookLog() }
        #expect(throws: ProgressStoreError.unavailable) { try store.activeLesson() }
    }

    /// SwiftData does not throw here: it hands back a store in memory, which would read as a cook with no answers.
    @Test func aStoreFileThatCannotBeMadeIsNotReplacedByAStoreInMemory() {
        let impossible = StoreLocation.file(URL(filePath: "/dev/null/Tomi.store"))
        #expect(throws: ProgressStoreError.unavailable) { _ = try StoreFixture(at: impossible) }
        #expect(throws: ProgressStoreError.unavailable) { try open(at: impossible).profile() }
    }

    @Test func aStoreFileThatIsNotADatabaseFailsEveryRead() throws {
        let location = try StoreFixture.temporaryFile()
        guard case .file(let file) = location else {
            return
        }
        try Data("not a database".utf8).write(to: file)
        #expect(throws: ProgressStoreError.unavailable) { try open(at: location).profile() }
    }

    @Test func aStoreThatCannotBeOpenedTakesNoWrites() {
        let store = open(["--store-unavailable"])
        #expect(throws: ProgressStoreError.unavailable) { try store.saveProfile(CookProfile(), at: .october(5)) }
        #expect(throws: ProgressStoreError.unavailable) { try store.add(.fixture("eggs", onOctober: 5)) }
        #expect(throws: ProgressStoreError.unavailable) { try store.clearActiveLesson() }
    }

    @Test func aKnownStateThatCannotBeBuiltLeavesNoHalfSeededStore() {
        let options = StoreLaunchOptions(arguments: ["--store-in-memory", "--seed-known-state"])
        let store = ProgressStoreOpener.store(for: options, catalog: nil)
        #expect(throws: ProgressStoreError.unavailable) { try store.profile() }
    }

    @Test func aStoreThatStartsEmptyForgetsWhatAnEarlierLaunchSaved() throws {
        let location = try StoreFixture.temporaryFile()
        let earlier = StoreLaunchOptions(location: location, seedsKnownState: false)
        var profile = CookProfile()
        profile.diet = "fake-veg"
        try ProgressStoreOpener.store(for: earlier, catalog: catalog).saveProfile(profile, at: .october(5))

        let later = StoreLaunchOptions(location: location, seedsKnownState: false, startsEmpty: true)
        let store = ProgressStoreOpener.store(for: later, catalog: catalog)

        #expect(try store.profile().diet == nil)
    }

    private func open(at location: StoreLocation) -> any ProgressStore {
        let options = StoreLaunchOptions(location: location, seedsKnownState: false)
        return ProgressStoreOpener.store(for: options, catalog: catalog)
    }

    private func open(_ arguments: [String]) -> any ProgressStore {
        ProgressStoreOpener.store(for: StoreLaunchOptions(arguments: arguments), catalog: catalog)
    }
}
