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
        let api = FakeTomiAPI(configuration: .init(progressServer: server))
        await harness.upload(with: harness.uploader(api))
        #expect(try harness.store.pendingCookEntries(for: CookEntry.fixtureAccount).isEmpty)
        #expect(try harness.store.progressSnapshot() == (try FakeProgressFixture.returning.snapshot()))
    }

    /// A read of the progress that finished later can have been kept already, with a newer snapshot than the answer.
    @Test func anAnswerWithAnOlderSnapshotThanTheOneKeptDoesNotReplaceIt() async throws {
        try harness.saveCooks(1)
        let newer = ProgressSnapshotBody.example(xp: 999, computedAt: "2030-01-01T00:00:00Z")
        try harness.store.saveProgressSnapshot(newer, at: .october(26))
        let api = FakeTomiAPI(
            configuration: .init(progressServer: FakeProgressServer(fixture: .returning))
        )
        await harness.upload(with: harness.uploader(api))
        #expect(try harness.store.progressSnapshot()?.xp == 999)
        #expect(try harness.store.pendingCookEntries(for: CookEntry.fixtureAccount).isEmpty)
    }

    @Test func onlineEachCookIsSentInItsOwnRequestWithTheCooksCalendar() async throws {
        let ids = try harness.saveCooks(2)
        let api = ScriptedProgressAPI(ScriptedReply.accepting)
        await harness.upload(with: harness.uploader(api))
        let sent = await api.sent
        #expect(sent.map(\.entry.id) == ids)
        #expect(sent.allSatisfy { $0.calendar == CalendarContext(timeZone: "Europe/Amsterdam", firstWeekday: 2) })
    }

    @Test func offlineEveryCookIsKeptAndEachNextTryWaitsLonger() async throws {
        let harness = UploaderHarness(wakes: 1)
        let ids = try harness.saveCooks(2)
        let offline = FakeProgressServer(isOffline: true)
        let api = FakeTomiAPI(configuration: .init(progressServer: offline))
        var waits = harness.sleeper.requests.makeAsyncIterator()
        let uploader = harness.uploader(api)
        uploader.upload()
        #expect(await waits.next() == .seconds(2))
        #expect(await waits.next() == .seconds(4))
        #expect(try harness.store.pendingCookEntries(for: CookEntry.fixtureAccount).map(\.id) == ids)
    }

    /// The server is idempotent on each cook's id, so a cook sent again can never count twice.
    @Test func aCookSentAgainKeepsTheSameID() async throws {
        let ids = try harness.saveCooks(1)
        let api = ScriptedProgressAPI(ScriptedReply.failing(.unreachable), ScriptedReply.accepting)
        let uploader = harness.uploader(api)
        await harness.upload(with: uploader)
        await harness.upload(with: uploader)
        #expect(await api.sent.map(\.entry.id) == ids + ids)
        #expect(try harness.store.pendingCookEntries(for: CookEntry.fixtureAccount).isEmpty)
    }

    @Test func theTimerSendsTheSameCookAgain() async throws {
        let harness = UploaderHarness(wakes: 1)
        let ids = try harness.saveCooks(1)
        let api = ScriptedProgressAPI(ScriptedReply.failing(.unreachable), ScriptedReply.accepting)
        var arrivals = api.arrivals.makeAsyncIterator()
        let uploader = harness.uploader(api)
        uploader.upload()
        #expect(await arrivals.next()?.entry.id == ids[0])
        #expect(await arrivals.next()?.entry.id == ids[0])
    }
}
