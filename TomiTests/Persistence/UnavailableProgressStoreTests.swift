import Foundation
import Testing
import TomiCore

@testable import Tomi

/// A store that could not be opened fails the outbox and the snapshot too: nothing reads it as an empty outbox,
/// and no snapshot is ever made up for it.
@MainActor
@Suite struct UnavailableProgressStoreTests {
    let store = UnavailableProgressStore()

    @Test func everyReadFails() {
        #expect(throws: ProgressStoreError.unavailable) { try store.pendingCookEntries() }
        #expect(throws: ProgressStoreError.unavailable) { try store.progressSnapshot() }
    }

    @Test func everyWriteFails() {
        let body = ProgressSnapshotBody.example()
        #expect(throws: ProgressStoreError.unavailable) { try store.forgetCookEntries(ids: [UUID()]) }
        #expect(throws: ProgressStoreError.unavailable) { try store.markCookEntryRefused(id: UUID(), code: "x") }
        #expect(throws: ProgressStoreError.unavailable) { try store.saveProgressSnapshot(body, at: .october(5)) }
    }
}
