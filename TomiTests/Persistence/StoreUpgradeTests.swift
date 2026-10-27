import Foundation
import Testing
import TomiCore

@testable import Tomi

/// A store file written by an earlier app version opens with the new layout and loses nothing.
@MainActor
@Suite struct StoreUpgradeTests {
    /// A cook saved before the account was recorded is kept and read, but no account may send it: it could belong to
    /// anyone who signed in on this phone.
    @Test func cooksSavedByAnEarlierVersionAreKeptWithoutAZoneAnAccountOrARefusalAndSentByNoOne() throws {
        let file = try StoreFixture.temporaryFile()
        let id = UUID()
        try EarlierStoreLayout.writeCook(.init(id: id, skill: "eggs", date: .october(5)), to: file)

        let store = try StoreFixture(at: file).store
        let kept = try store.cookLog()
        #expect(kept.map(\.id) == [id])
        #expect(kept.map(\.session.timeZone) == [nil])
        #expect(kept.map(\.account) == [nil])
        #expect(try store.pendingCookEntries(for: CookEntry.fixtureAccount).isEmpty)
        #expect(try store.progressSnapshot() == nil)
    }
}
