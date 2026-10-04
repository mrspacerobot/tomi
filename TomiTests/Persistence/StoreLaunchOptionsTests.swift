import Foundation
import Testing

@testable import Tomi

/// The launch arguments UI tests pass to choose where saved data lives.
@Suite struct StoreLaunchOptionsTests {
    @Test func withoutArgumentsTheCooksOwnStoreIsUsedAndNothingIsSeeded() {
        let options = StoreLaunchOptions(arguments: ["Tomi"])
        #expect(options.location == .phone)
        #expect(!options.seedsKnownState)
    }

    @Test func eachArgumentChoosesItsLocation() {
        #expect(StoreLaunchOptions(arguments: ["--store-in-memory"]).location == .memory)
        #expect(StoreLaunchOptions(arguments: ["--store-ui-test-file"]).location == .uiTestFile)
        #expect(StoreLaunchOptions(arguments: ["--store-unavailable"]).location == .unavailable)
    }

    @Test func aTestStoreCanBeSeeded() {
        #expect(StoreLaunchOptions(arguments: ["--store-in-memory", "--seed-known-state"]).seedsKnownState)
        #expect(StoreLaunchOptions(arguments: ["--store-ui-test-file", "--seed-known-state"]).seedsKnownState)
    }

    @Test func theUnwritableTestFileNeverUsesTheCooksOwnStore() {
        let options = StoreLaunchOptions(arguments: ["--store-ui-test-unwritable-file"])
        #expect(options.location == .file(URL(filePath: "/dev/null/TomiUITests.store")))
        #expect(!options.location.isTheCooksOwn)
    }

    /// Seeding empties the store first, so it must never reach the cook's own.
    @Test func theCooksOwnStoreIsNeverSeeded() {
        let options = StoreLaunchOptions(arguments: ["Tomi", "--seed-known-state"])
        #expect(options.location == .phone)
        #expect(!options.seedsKnownState)
    }

    @Test func ofSeveralLocationsTheOneThatKeepsTheLeastWins() {
        let memoryAndFile = ["--store-ui-test-file", "--store-in-memory"]
        #expect(StoreLaunchOptions(arguments: memoryAndFile).location == .memory)
        #expect(StoreLaunchOptions(arguments: memoryAndFile + ["--store-unavailable"]).location == .unavailable)
    }
}
