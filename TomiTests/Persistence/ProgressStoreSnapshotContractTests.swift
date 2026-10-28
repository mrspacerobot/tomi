import Foundation
import Testing
import TomiCore

@testable import Tomi

/// The last progress snapshot, as every `ProgressStore` keeps it. What cannot be read is no snapshot, never zeros.
@MainActor
@Suite struct ProgressStoreSnapshotContractTests {
    @Test(arguments: StoreKind.allCases)
    func anEmptyStoreHasNoSnapshot(kind: StoreKind) throws {
        #expect(try kind.emptyStore().progressSnapshot() == nil)
    }

    @Test(arguments: StoreKind.allCases)
    func aSavedSnapshotIsReadAsTheServerSentIt(kind: StoreKind) throws {
        let store = try kind.emptyStore()
        try store.saveProgressSnapshot(ProgressSnapshotBody.example(), at: .october(5))
        let sent = try JSONDecoder().decode(ProgressSnapshot.self, from: ProgressSnapshotBody.example())
        #expect(try store.progressSnapshot() == sent)
    }

    @Test(arguments: StoreKind.allCases)
    func theSnapshotSavedLastReplacesTheOneBefore(kind: StoreKind) throws {
        let store = try kind.emptyStore()
        try store.saveProgressSnapshot(ProgressSnapshotBody.example(xp: 360), at: .october(5))
        try store.saveProgressSnapshot(ProgressSnapshotBody.example(xp: 420), at: .october(6))
        #expect(try store.progressSnapshot()?.xp == 420)
    }

    @Test(arguments: StoreKind.allCases)
    func aSnapshotThatCannotBeReadIsNoSnapshot(kind: StoreKind) throws {
        let store = try kind.emptyStore()
        try store.saveProgressSnapshot(ProgressSnapshotBody.example(), at: .october(5))
        try store.saveProgressSnapshot(ProgressSnapshotBody.unknownLayout, at: .october(6))
        #expect(try store.progressSnapshot() == nil)
    }

    @Test(arguments: StoreKind.allCases)
    func savingASnapshotLeavesTheCooksAlone(kind: StoreKind) throws {
        let cook = CookEntry.fixture("eggs", onOctober: 5)
        let store = try kind.storeHolding([cook])
        try store.saveProgressSnapshot(ProgressSnapshotBody.example(), at: .october(6))
        #expect(try store.pendingCookEntries(for: CookEntry.fixtureAccount) == [cook])
    }

    @Test(arguments: StoreKind.allCases)
    func snapshotsBelongToTheirAccounts(kind: StoreKind) throws {
        let store = try kind.emptyStore()
        try store.saveProgressSnapshot(ProgressSnapshotBody.example(xp: 360), at: .october(5), for: "a")
        try store.saveProgressSnapshot(ProgressSnapshotBody.example(xp: 420), at: .october(6), for: "b")
        #expect(try store.progressSnapshot(for: "a")?.xp == 360)
        #expect(try store.progressSnapshot(for: "b")?.xp == 420)
        #expect(try store.progressSnapshot(for: "c") == nil)
    }

    @Test(arguments: StoreKind.allCases)
    func aSnapshotWithoutAnOwnerIsNotShownForAnyAccount(kind: StoreKind) throws {
        let store = try kind.emptyStore()
        try store.saveProgressSnapshot(ProgressSnapshotBody.example(), at: .october(5))
        #expect(try store.progressSnapshot(for: "a") == nil)
    }
}
