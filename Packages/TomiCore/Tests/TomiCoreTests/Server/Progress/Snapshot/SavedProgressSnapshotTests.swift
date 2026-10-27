import Foundation
import Testing

@testable import TomiCore

/// The last snapshot kept on the phone, read out of every snapshot record in the store, in any order.
/// What cannot be read is no snapshot, never a snapshot of zeros.
@Suite struct SavedProgressSnapshotTests {
    let older = SavedProgressSnapshot.received(ProgressJSON.snapshot, on: .october(5))
    let newer = SavedProgressSnapshot.received(
        ProgressJSON.snapshot(setting: ["xp"], to: 420),
        on: .october(6)
    )

    @Test func theSnapshotReceivedLastIsReadInEitherOrder() {
        #expect([older, newer].lastSnapshot?.xp == 420)
        #expect([newer, older].lastSnapshot?.xp == 420)
    }

    @Test func theBodyIsReadExactlyAsTheServerSentIt() throws {
        let sent = try ServerJSON.decode(ProgressSnapshot.self, from: ProgressJSON.snapshot)
        #expect([older].lastSnapshot == sent)
    }

    @Test func noRecordIsNoSnapshot() {
        #expect([SavedProgressSnapshot]().lastSnapshot == nil)
    }

    @Test func aRecordWithoutABodyIsNoSnapshot() {
        var empty = newer
        empty.body = nil
        #expect([empty].lastSnapshot == nil)
    }

    /// An unreadable newest snapshot is not swapped for an older one: the phone asks the server again.
    @Test func aNewestBodyThatCannotBeReadIsNoSnapshot() {
        let unknownLayout = SavedProgressSnapshot.received(
            ProgressJSON.snapshot(setting: ["schemaVersion"], to: 2),
            on: .october(7)
        )
        let broken = SavedProgressSnapshot.received("{\"xp\":", on: .october(7))
        #expect([older, unknownLayout].lastSnapshot == nil)
        #expect([broken, older].lastSnapshot == nil)
    }

    @Test func twoCopiesWithTheSameStampThatDisagreeAreNoSnapshot() {
        var copy = newer
        copy.body = older.body
        #expect([newer, copy].lastSnapshot == nil)
        #expect([copy, newer].lastSnapshot == nil)
    }

    @Test func aRecordIsStampedByTheMomentItWasReceived() {
        #expect(newer.updatedAt == newer.receivedAt)
        #expect(newer.isNewer(than: older))
    }
}

extension SavedProgressSnapshot {
    fileprivate static func received(_ body: String, on day: DateComponents) -> SavedProgressSnapshot {
        var saved = SavedProgressSnapshot()
        saved.stableID = UUID()
        saved.receivedAt = TestCalendar().date(day)
        saved.body = Data(body.utf8)
        return saved
    }
}
