import Foundation
import Testing
import TomiCore

@testable import Tomi

/// What is saved is still there when the store file is opened again, as after the app was closed.
@MainActor
@Suite struct StorePersistenceTests {
    let file: StoreLocation

    init() throws {
        file = try StoreFixture.temporaryFile()
    }

    @Test func theProfileSurvivesReopeningTheStore() throws {
        try StoreFixture(at: file).store.saveProfile(.fixtureWithEveryAnswerChanged(), at: .october(5))
        #expect(try StoreFixture(at: file).store.profile() == .fixtureWithEveryAnswerChanged())
    }

    @Test func theCookLogSurvivesReopeningTheStore() throws {
        let cooks = [CookEntry.fixture("eggs", onOctober: 5), CookEntry.fixture("eggs", onOctober: 6)]
        let store = try StoreFixture(at: file).store
        try store.add(cooks[0])
        try store.add(cooks[1])
        #expect(try StoreFixture(at: file).store.cookLog() == cooks)
    }

    @Test func theBookmarkSurvivesReopeningTheStore() throws {
        try StoreFixture(at: file).store.saveActiveLesson(.fixture("an-omelette", onStep: 2), at: .october(5))
        #expect(try StoreFixture(at: file).store.activeLesson() == .fixture("an-omelette", onStep: 2))
    }

    /// An empty kitchen is an answer, and no answer is not: the store must keep the two apart.
    @Test func anEmptyListAndAMissingListStayDifferentOnDisk() throws {
        var emptyKitchen = CookProfile()
        emptyKitchen.equipment = []
        try StoreFixture(at: file).store.saveProfile(emptyKitchen, at: .october(5))
        #expect(try StoreFixture(at: file).store.profile().equipment == [])
        try StoreFixture(at: file).store.saveProfile(CookProfile(), at: .october(6))
        #expect(try StoreFixture(at: file).store.profile().equipment == nil)
    }
}
