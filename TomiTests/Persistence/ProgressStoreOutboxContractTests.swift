import Foundation
import Testing
import TomiCore

@testable import Tomi

/// The outbox of unsent cooks, as every `ProgressStore` keeps it: checked against the store on the phone and the
/// fake, so a test that runs on the fake says something about the real one.
@MainActor
@Suite struct ProgressStoreOutboxContractTests {
    let monday = CookEntry.fixture("knife-cuts", onOctober: 5)
    let tuesday = CookEntry.fixture("eggs", onOctober: 6)
    let wednesday = CookEntry.fixture("eggs", onOctober: 7)

    @Test(arguments: StoreKind.allCases)
    func anEmptyStoreHasNothingToSend(kind: StoreKind) throws {
        #expect(try kind.emptyStore().pendingCookEntries().isEmpty)
    }

    @Test(arguments: StoreKind.allCases)
    func everySavedCookIsPendingOnceOldestFirst(kind: StoreKind) throws {
        let store = try kind.storeHolding([wednesday, monday, tuesday, monday])
        #expect(try store.pendingCookEntries() == [monday, tuesday, wednesday])
    }

    @Test(arguments: StoreKind.allCases)
    func forgottenCooksLeaveTheOutboxAndTheRestStay(kind: StoreKind) throws {
        let store = try kind.storeHolding([monday, tuesday, wednesday])
        try store.forgetCookEntries(ids: [monday.id, wednesday.id])
        #expect(try store.pendingCookEntries() == [tuesday])
        #expect(try store.cookLog() == [tuesday])
    }

    @Test(arguments: StoreKind.allCases)
    func forgettingACookTheStoreDoesNotHoldChangesNothing(kind: StoreKind) throws {
        let store = try kind.storeHolding([monday])
        try store.forgetCookEntries(ids: [UUID()])
        try store.forgetCookEntries(ids: [])
        #expect(try store.pendingCookEntries() == [monday])
    }

    /// A refused cook is never sent again, and stays on the phone: nothing the cook did is lost.
    @Test(arguments: StoreKind.allCases)
    func aRefusedCookIsNoLongerPendingAndStaysInTheLog(kind: StoreKind) throws {
        let store = try kind.storeHolding([monday, tuesday])
        try store.markCookEntryRefused(id: monday.id, code: "cooked_in_future")
        #expect(try store.pendingCookEntries() == [tuesday])
        #expect(try store.cookLog() == [monday, tuesday])
    }

    @Test(arguments: StoreKind.allCases)
    func refusingACookTheStoreDoesNotHoldChangesNothing(kind: StoreKind) throws {
        let store = try kind.storeHolding([monday])
        try store.markCookEntryRefused(id: UUID(), code: "cooked_in_future")
        #expect(try store.pendingCookEntries() == [monday])
    }

    @Test(arguments: StoreKind.allCases)
    func aCookKeepsTheZoneItWasCookedIn(kind: StoreKind) throws {
        let tokyo = CookEntry.fixture("eggs", onOctober: 5).cooked(in: "Asia/Tokyo")
        let store = try kind.storeHolding([tokyo, tuesday])
        #expect(try store.pendingCookEntries().map(\.session.timeZone) == [TimeZone(identifier: "Asia/Tokyo"), nil])
        #expect(try store.cookLog() == [tokyo, tuesday])
    }
}
