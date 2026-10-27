import Foundation
import Testing
import TomiCore

@testable import Tomi

/// The store keeps a snapshot unless it is older than the one it holds.
@MainActor
@Suite struct ProgressStoreKeepingTests {
    let store = InMemoryProgressStore()

    @Test func aNewerSnapshotIsKept() throws {
        try store.saveProgressSnapshot(ProgressSnapshotBody.example(xp: 100), at: .october(26))
        let newer = ProgressSnapshotBody.example(xp: 200, computedAt: "2026-10-26T18:43:03Z")
        #expect(try store.keepProgressSnapshot(newer, at: .october(27)))
        #expect(try store.progressSnapshot()?.xp == 200)
    }

    @Test func anOlderSnapshotIsNotKept() throws {
        try store.saveProgressSnapshot(ProgressSnapshotBody.example(xp: 100), at: .october(26))
        let older = ProgressSnapshotBody.example(xp: 50, computedAt: "2026-10-26T18:43:01Z")
        #expect(try !store.keepProgressSnapshot(older, at: .october(27)))
        #expect(try store.progressSnapshot()?.xp == 100)
    }

    @Test func aBodyThatCannotBeReadIsNotKept() throws {
        try store.saveProgressSnapshot(ProgressSnapshotBody.example(xp: 100), at: .october(26))
        #expect(try !store.keepProgressSnapshot(Data("{}".utf8), at: .october(27)))
        #expect(try store.progressSnapshot()?.xp == 100)
    }

    @Test func savedDataThatCannotBeReadKeepsNothing() {
        #expect(throws: ProgressStoreError.unavailable) {
            try UnavailableProgressStore().keepProgressSnapshot(ProgressSnapshotBody.example(), at: .october(27))
        }
    }
}
