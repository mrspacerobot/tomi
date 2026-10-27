import Foundation
import Testing
import TomiCore

@testable import Tomi

/// A store file written by an earlier app version opens with the new layout and loses nothing.
@MainActor
@Suite struct StoreUpgradeTests {
    @Test func cooksSavedByAnEarlierVersionArePendingWithoutAZoneOrARefusal() throws {
        let file = try StoreFixture.temporaryFile()
        let id = UUID()
        try EarlierStoreLayout.writeCook(.init(id: id, skill: "eggs", date: .october(5)), to: file)

        let store = try StoreFixture(at: file).store
        let pending = try store.pendingCookEntries()
        #expect(pending.map(\.id) == [id])
        #expect(pending.map(\.session.timeZone) == [nil])
        #expect(try store.progressSnapshot() == nil)
    }
}
