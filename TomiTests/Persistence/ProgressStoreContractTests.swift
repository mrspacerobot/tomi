import Foundation
import Testing
import TomiCore

@testable import Tomi

/// What every `ProgressStore` promises a screen, checked against the store on the phone and against the fake,
/// so a test that runs on the fake says something about the real one.
@MainActor
@Suite struct ProgressStoreContractTests {
    @Test(arguments: StoreKind.allCases)
    func anEmptyStoreGivesTheDefaultsAndNothingElse(kind: StoreKind) throws {
        let store = try kind.emptyStore()
        #expect(try store.profile() == CookProfile())
        #expect(try store.cookLog().isEmpty)
    }

    @Test(arguments: StoreKind.allCases)
    func everyAnswerOfASavedProfileIsReadBack(kind: StoreKind) throws {
        let store = try kind.emptyStore()
        try store.saveProfile(.fixtureWithEveryAnswerChanged(), at: .october(5))
        #expect(try store.profile() == .fixtureWithEveryAnswerChanged())
    }

    @Test(arguments: StoreKind.allCases)
    func theProfileSavedLastReplacesTheOneBefore(kind: StoreKind) throws {
        let store = try kind.emptyStore()
        try store.saveProfile(.fixture(diet: "vegan", avoid: ["nuts"]), at: .october(5))
        try store.saveProfile(.fixture(diet: nil, avoid: ["pork"]), at: .october(6))
        #expect(try store.profile() == .fixture(diet: nil, avoid: ["pork"]))
    }

    @Test(arguments: StoreKind.allCases)
    func theCookLogIsReadOldestFirst(kind: StoreKind) throws {
        let store = try kind.emptyStore()
        let monday = CookEntry.fixture("knife-cuts", onOctober: 5)
        let tuesday = CookEntry.fixture("eggs", onOctober: 6)
        try store.add(tuesday)
        try store.add(monday)
        #expect(try store.cookLog() == [monday, tuesday])
    }

    @Test(arguments: StoreKind.allCases)
    func theSameCookAddedTwiceIsKeptOnce(kind: StoreKind) throws {
        let store = try kind.emptyStore()
        let cook = CookEntry.fixture("eggs", onOctober: 5)
        try store.add(cook)
        try store.add(cook)
        #expect(try store.cookLog() == [cook])
    }
}
