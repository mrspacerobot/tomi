import Foundation
import Testing
import TomiCore

@testable import Tomi

/// When the uploader must not send: while it already sends, after a request the server could not read, and when
/// there is nothing it can safely do. Every cook stays on the phone in each case.
@MainActor
@Suite(.timeLimit(.minutes(1))) struct CookEntryUploaderGuardTests {
    let harness = UploaderHarness()

    @Test func aSecondTriggerWhileAnUploadRunsStartsNothing() async throws {
        try harness.saveCooks(1)
        let api = ScriptedProgressAPI(holdingFirstAnswer: true, ScriptedReply.accepting)
        let uploader = harness.uploader(api)
        var arrivals = api.arrivals.makeAsyncIterator()
        uploader.upload()
        _ = await arrivals.next()
        uploader.upload()
        await api.releaseAnswer()
        await uploader.waitUntilIdle()
        #expect(await api.sent.count == 1)
    }

    /// The server could not read the request: sending it again would fail the same way, so it waits for a launch.
    @Test func aRequestTheServerCannotReadKeepsEveryCookUntilTheNextLaunch() async throws {
        let ids = try harness.saveCooks(2)
        let api = ScriptedProgressAPI(ScriptedReply.invalidRequest, ScriptedReply.accepting)
        let uploader = harness.uploader(api)
        await harness.upload(with: uploader)
        await harness.upload(with: uploader)
        #expect(await api.sent.count == 1)
        #expect(try harness.store.pendingCookEntries(for: CookEntry.fixtureAccount).map(\.id) == ids)
        await harness.upload(with: harness.uploader(api))
        // The next launch sends both cooks, one after the other; the script's last answer repeats.
        #expect(await api.sent.count == 3)
        #expect(try harness.store.pendingCookEntries(for: CookEntry.fixtureAccount).isEmpty)
    }

    @Test func aRequestTheServerCannotReadSetsNoTimer() async throws {
        try harness.saveCooks(1)
        let api = ScriptedProgressAPI(ScriptedReply.invalidRequest)
        let uploader = harness.uploader(api)
        await harness.upload(with: uploader)
        #expect(uploader.nextTryDelay == nil)
    }

    @Test func anUnreadable422HoldsTheOutboxUntilLaunch() async throws {
        try harness.saveCooks(1)
        let api = ScriptedProgressAPI(ScriptedReply.failing(.unreadableResponse(status: 422)))
        let uploader = harness.uploader(api)
        await harness.upload(with: uploader)
        await harness.upload(with: uploader)
        #expect(await api.sent.count == 1)
        #expect(uploader.nextTryDelay == nil)
        #expect(try harness.store.pendingCookEntries(for: CookEntry.fixtureAccount).count == 1)
    }

    /// Without a session no try can succeed, so the cooks wait for the cook to sign in again, which uploads.
    @Test func signedOutTheCooksWaitForTheNextSignIn() async throws {
        try harness.saveCooks(1)
        let api = ScriptedProgressAPI(ScriptedReply.failing(.notSignedIn))
        let uploader = harness.uploader(api)
        await harness.upload(with: uploader)
        #expect(uploader.nextTryDelay == nil)
        #expect(try harness.store.pendingCookEntries(for: CookEntry.fixtureAccount).count == 1)
    }

    /// An answer that changes nothing, such as a status this app does not know, is a failed try: the cooks stay and
    /// the next try waits, so the same cook is never sent in a tight loop.
    @Test func anAnswerThatChangesNothingWaitsBeforeTheNextTry() async throws {
        try harness.saveCooks(1)
        let api = ScriptedProgressAPI(ScriptedReply.answering(.unknown("parked")))
        var waits = harness.sleeper.requests.makeAsyncIterator()
        await harness.upload(with: harness.uploader(api))
        #expect(await waits.next() == .seconds(2))
        #expect(await api.sent.count == 1)
        #expect(try harness.store.pendingCookEntries(for: CookEntry.fixtureAccount).count == 1)
        #expect(try harness.store.progressSnapshot() == (try FakeProgressFixture.returning.snapshot()))
    }

    @Test func anEmptyOutboxSendsNothing() async {
        let api = ScriptedProgressAPI(ScriptedReply.accepting)
        await harness.upload(with: harness.uploader(api))
        #expect(await api.sent.isEmpty)
    }

    @Test func savedDataThatCannotBeReadSendsNothing() async {
        let api = ScriptedProgressAPI(ScriptedReply.accepting)
        let uploader = harness.uploader(api, over: UnavailableProgressStore())
        await harness.upload(with: uploader)
        #expect(await api.sent.isEmpty)
    }
}
