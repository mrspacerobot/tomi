import Foundation
import Testing
import TomiCore

@testable import Tomi

/// The uploader sends the outbox by itself, keeps every cook the server has not answered for, and tries again later.
@MainActor
@Suite(.timeLimit(.minutes(1))) struct CookEntryUploaderTests {
    let harness = UploaderHarness()

    @Test func onlineTheAcknowledgedCooksAreForgottenAndTheSnapshotIsSaved() async throws {
        try harness.saveCooks(2)
        let server = FakeProgressServer(fixture: .returning)
        let api = FakeTomiAPI(library: BundledLessonLibrary(), configuration: .init(progressServer: server))
        await harness.upload(with: harness.uploader(api))
        #expect(try harness.store.pendingCookEntries(for: CookEntry.fixtureAccount).isEmpty)
        #expect(try harness.store.progressSnapshot() == (try FakeProgressFixture.returning.snapshot()))
    }

    @Test func onlineTheOutboxIsSentOnceWithTheCooksCalendar() async throws {
        let ids = try harness.saveCooks(2)
        let api = ScriptedProgressAPI(ScriptedReply.acceptingAll)
        await harness.upload(with: harness.uploader(api))
        let sent = await api.sent
        #expect(sent.count == 1)
        #expect(sent.first?.entries.map(\.id) == ids)
        #expect(sent.first?.calendar == CalendarContext(timeZone: "Europe/Amsterdam", firstWeekday: 2))
    }

    @Test func offlineEveryCookIsKeptAndEachNextTryWaitsLonger() async throws {
        let harness = UploaderHarness(wakes: 1)
        let ids = try harness.saveCooks(2)
        let offline = FakeProgressServer(isOffline: true)
        let api = FakeTomiAPI(library: BundledLessonLibrary(), configuration: .init(progressServer: offline))
        var waits = harness.sleeper.requests.makeAsyncIterator()
        let uploader = harness.uploader(api)
        uploader.upload()
        #expect(await waits.next() == .seconds(2))
        #expect(await waits.next() == .seconds(4))
        #expect(try harness.store.pendingCookEntries(for: CookEntry.fixtureAccount).map(\.id) == ids)
    }

    /// The server is idempotent on each cook's id, so a batch sent again can never count twice.
    @Test func aBatchSentAgainKeepsTheSameIDs() async throws {
        let ids = try harness.saveCooks(2)
        let api = ScriptedProgressAPI(ScriptedReply.failing(.unreachable), ScriptedReply.acceptingAll)
        let uploader = harness.uploader(api)
        await harness.upload(with: uploader)
        await harness.upload(with: uploader)
        let sent = await api.sent
        #expect(sent.map { $0.entries.map(\.id) } == [ids, ids])
        #expect(try harness.store.pendingCookEntries(for: CookEntry.fixtureAccount).isEmpty)
    }

    @Test func theTimerSendsTheSameBatchAgain() async throws {
        let harness = UploaderHarness(wakes: 1)
        let ids = try harness.saveCooks(1)
        let api = ScriptedProgressAPI(ScriptedReply.failing(.unreachable), ScriptedReply.acceptingAll)
        var arrivals = api.arrivals.makeAsyncIterator()
        let uploader = harness.uploader(api)
        uploader.upload()
        #expect(await arrivals.next()?.entries.map(\.id) == ids)
        #expect(await arrivals.next()?.entries.map(\.id) == ids)
    }

    /// A rejected cook stays on the phone, marked with the server's code, and is never sent again.
    @Test func aRejectedCookIsNeverSentAgain() async throws {
        let ids = try harness.saveCooks(2)
        let reply = ScriptedReply.answering([.rejected, .accepted], problems: ["cooked_in_future"])
        let api = ScriptedProgressAPI(reply, ScriptedReply.acceptingAll)
        let uploader = harness.uploader(api)
        await harness.upload(with: uploader)
        await harness.upload(with: uploader)
        #expect(await api.sent.count == 1)
        #expect(try harness.store.pendingCookEntries(for: CookEntry.fixtureAccount).isEmpty)
        #expect(try harness.store.cookLog().map(\.id) == [ids[0]])
    }

    @Test func anOutboxOverOneBatchIsSentBatchAfterBatch() async throws {
        try harness.saveCooks(CookOutbox.largestBatch + 1)
        let api = ScriptedProgressAPI(ScriptedReply.acceptingAll)
        await harness.upload(with: harness.uploader(api))
        #expect(await api.sent.map(\.entries.count) == [CookOutbox.largestBatch, 1])
        #expect(try harness.store.pendingCookEntries(for: CookEntry.fixtureAccount).isEmpty)
    }
}
