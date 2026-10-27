import Foundation
import Testing
import TomiCore

@testable import Tomi

/// Home's progress: the snapshot saved last at once, then the server's, with a kind note offline.
/// The phone adds no cook, XP or rank of its own.
@MainActor
@Suite struct ProgressModelTests {
    @Test func theSavedSnapshotIsShownAtOnceBeforeTheServerIsAsked() throws {
        let store = try ProgressModelHarness.storeWithSnapshot()
        let model = ProgressModelHarness.model(store: store, server: .returning)
        #expect(model.shown?.snapshot?.xp == 360)
        #expect(model.shown?.note == nil)
    }

    @Test func savedDataThatCannotBeReadShowsNothing() {
        let model = ProgressModelHarness.model(store: UnavailableProgressStore(), server: .returning)
        #expect(model.shown == nil)
    }

    @Test func theServersSnapshotIsShownAndKept() async throws {
        let store = InMemoryProgressStore()
        let model = ProgressModelHarness.model(store: store, server: .returning)
        await model.refresh()
        #expect(model.shown?.snapshot?.xp == 350)
        #expect(try store.progressSnapshot()?.xp == 350)
        #expect(model.shown?.note == nil)
    }

    @Test func offlineWithUnsentCooksTheNoteCountsThemAndTheXPStaysTheLastSnapshots() async throws {
        let store = try ProgressModelHarness.storeWithSnapshot()
        try store.add(.fixture("eggs", onOctober: 26))
        try store.add(.fixture("eggs", onOctober: 27))
        let model = ProgressModelHarness.model(store: store, server: .offline)
        await model.refresh()
        #expect(model.shown?.note == .unsentCooks(2))
        #expect(model.shown?.snapshot?.xp == 360)
    }

    @Test func withoutASnapshotOfflineTheNoteSaysProgressShowsOnlineAndNoNumbersAreShown() async {
        let model = ProgressModelHarness.model(store: InMemoryProgressStore(), server: .offline)
        await model.refresh()
        #expect(model.shown?.note == .showsWhenOnline)
        #expect(model.shown?.snapshot == nil)
    }

    @Test func aSnapshotPastTheEndOfItsWeekHidesThisWeeksDays() throws {
        let store = try ProgressModelHarness.storeWithSnapshot()
        let model = ProgressModelHarness.model(store: store, server: .offline, now: .november(3))
        #expect(model.shown?.showsThisWeek == false)
        #expect(ProgressModelHarness.model(store: store, server: .offline).shown?.showsThisWeek == true)
    }

    /// The uploader keeps the snapshot of each answer and forgets the cooks it acknowledged.
    @Test func readingTheStoreAgainShowsWhatTheUploaderKept() async throws {
        let store = try ProgressModelHarness.storeWithSnapshot()
        try store.add(.fixture("eggs", onOctober: 26))
        let model = ProgressModelHarness.model(store: store, server: .offline)
        await model.refresh()
        try store.forgetCookEntries(ids: Set(try store.pendingCookEntries().map(\.id)))
        try store.saveProgressSnapshot(ProgressSnapshotBody.example(xp: 410), at: .october(27))
        model.reload()
        #expect(model.shown?.snapshot?.xp == 410)
        #expect(model.shown?.note == nil)
    }

    @Test func backOnlineTheNoteGoes() async throws {
        let store = try ProgressModelHarness.storeWithSnapshot()
        try store.add(.fixture("eggs", onOctober: 26))
        let offline = ProgressModelHarness.model(store: store, server: .offline)
        await offline.refresh()
        #expect(offline.shown?.note == .unsentCooks(1))
        let online = ProgressModelHarness.model(store: store, server: .returning)
        await online.refresh()
        #expect(online.shown?.note == nil)
        #expect(online.shown?.snapshot?.xp == 350)
    }
}
