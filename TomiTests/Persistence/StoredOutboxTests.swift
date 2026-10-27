import Foundation
import Testing
import TomiCore

@testable import Tomi

/// The outbox and the snapshot in the SwiftData store, including what iCloud can do to them: one cook or one
/// snapshot as two records, put in behind the store's back.
@MainActor
@Suite struct StoredOutboxTests {
    let fixture: StoreFixture
    let cook = CookEntry.fixture("eggs", onOctober: 5)

    init() throws {
        fixture = try StoreFixture()
    }

    @Test func forgettingACookDeletesEveryCopyOfIt() throws {
        try fixture.insertCook(SavedCookEntry(cook))
        try fixture.insertCook(SavedCookEntry(cook))
        try fixture.store.forgetCookEntries(ids: [cook.id])
        #expect(try fixture.count(of: CookLogRecord.self) == 0)
    }

    @Test func refusingACookMarksEveryCopyWithTheCode() throws {
        try fixture.insertCook(SavedCookEntry(cook))
        try fixture.insertCook(SavedCookEntry(cook))
        try fixture.store.markCookEntryRefused(id: cook.id, code: "cooked_in_future")
        let codes = try fixture.cookRecords().map(\.refusedCode)
        #expect(codes == ["cooked_in_future", "cooked_in_future"])
    }

    @Test func aRecordThatCannotBeReadIsNeverPendingAndIsKept() throws {
        var broken = SavedCookEntry(.fixture("eggs", onOctober: 6))
        broken.date = nil
        try fixture.insertCook(broken)
        try fixture.store.add(cook)
        #expect(try fixture.store.pendingCookEntries(for: CookEntry.fixtureAccount) == [cook])
        try fixture.store.forgetCookEntries(ids: [cook.id])
        #expect(try fixture.count(of: CookLogRecord.self) == 1)
    }

    @Test func twoSnapshotRecordsReadAsTheNewestInEitherOrder() throws {
        try fixture.insertSnapshot(ProgressSnapshotBody.example(xp: 420), receivedOnOctober: 6)
        try fixture.insertSnapshot(ProgressSnapshotBody.example(xp: 360), receivedOnOctober: 5)
        #expect(try fixture.store.progressSnapshot()?.xp == 420)
    }

    @Test func savingASnapshotLeavesOneRecordBehind() throws {
        try fixture.insertSnapshot(ProgressSnapshotBody.example(xp: 360), receivedOnOctober: 5)
        try fixture.insertSnapshot(ProgressSnapshotBody.example(xp: 380), receivedOnOctober: 6)
        try fixture.store.saveProgressSnapshot(ProgressSnapshotBody.example(xp: 420), at: .october(7))
        #expect(try fixture.count(of: ProgressSnapshotRecord.self) == 1)
        #expect(try fixture.store.progressSnapshot()?.xp == 420)
    }

    @Test func theSnapshotRecordHoldsTheBodyExactlyAsReceived() throws {
        try fixture.store.saveProgressSnapshot(ProgressSnapshotBody.unknownLayout, at: .october(5))
        let records = try fixture.snapshotRecords()
        #expect(records.map(\.body) == [ProgressSnapshotBody.unknownLayout])
        #expect(records.map(\.receivedAt) == [.october(5)])
    }
}
