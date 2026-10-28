import Foundation
import Testing
import TomiCore

@testable import Tomi

/// The outbox is sent one cook after another, oldest first. A cook the server refuses, and a cook it cannot take,
/// never hold back the cooks after them.
@MainActor
@Suite(.timeLimit(.minutes(1))) struct CookEntryUploaderOrderTests {
    let harness = UploaderHarness()

    /// A rejected cook stays on the phone, marked with the server's code, and is never sent again. The cook after it
    /// is still sent.
    @Test func aRejectedCookIsNeverSentAgain() async throws {
        let ids = try harness.saveCooks(2)
        let reply = ScriptedReply.answering(.rejected, problems: ["cooked_in_future"])
        let api = ScriptedProgressAPI(reply, ScriptedReply.accepting)
        let uploader = harness.uploader(api)
        await harness.upload(with: uploader)
        await harness.upload(with: uploader)
        #expect(await api.sent.map(\.entry.id) == ids)
        #expect(try harness.store.pendingCookEntries(for: CookEntry.fixtureAccount).isEmpty)
        #expect(try harness.store.cookLog().map(\.id) == [ids[0]])
    }

    @Test func anOutboxOfManyCooksIsSentOneAfterAnother() async throws {
        let ids = try harness.saveCooks(5)
        let api = ScriptedProgressAPI(ScriptedReply.accepting)
        await harness.upload(with: harness.uploader(api))
        #expect(await api.sent.map(\.entry.id) == ids)
        #expect(try harness.store.pendingCookEntries(for: CookEntry.fixtureAccount).isEmpty)
    }

    /// The server takes only graph recipes. A cook of a bundled lesson stays on the phone, is never sent, and does
    /// not hold back the cooks after it.
    @Test func aCookOfABundledLessonIsNeverSentAndStaysOnThePhone() async throws {
        let bundled = CookEntry.fixture("eggs", onOctober: 1).ofABundledLesson()
        try harness.store.add(bundled)
        let ids = try harness.saveCooks(1)
        let api = ScriptedProgressAPI(ScriptedReply.accepting)
        await harness.upload(with: harness.uploader(api))
        #expect(await api.sent.map(\.entry.id) == ids)
        #expect(try harness.store.cookLog().map(\.id) == [bundled.id])
    }
}
