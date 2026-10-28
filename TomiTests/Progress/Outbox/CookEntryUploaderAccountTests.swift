import Foundation
import Testing
import TomiCore

@testable import Tomi

/// The cooks of one account are never sent with the credentials of another who signs in on the same phone.
@MainActor
@Suite(.timeLimit(.minutes(1))) struct CookEntryUploaderAccountTests {
    let harness = UploaderHarness()
    let strangers = CookEntry.fixture("eggs", onOctober: 3).cooked(by: "another-cook")
    let unowned = CookEntry.fixture("eggs", onOctober: 4).cooked(by: nil)

    @Test func theCooksOfAnotherAccountAreNotSentAndStayOnThePhone() async throws {
        try harness.store.add(strangers)
        try harness.store.add(unowned)
        let own = try harness.saveCooks(1)
        let api = ScriptedProgressAPI(ScriptedReply.accepting)
        await harness.upload(with: harness.uploader(api))
        #expect(await api.sent.map(\.entry.id) == own)
        #expect(try harness.store.cookLog().map(\.id).contains(strangers.id))
        #expect(try harness.store.cookLog().map(\.id).contains(unowned.id))
    }

    @Test func whenNobodyIsSignedInNothingIsSent() async throws {
        try harness.saveCooks(2)
        try await harness.auth.signOut()
        let api = ScriptedProgressAPI(ScriptedReply.accepting)
        await harness.upload(with: harness.uploader(api))
        #expect(await api.sent.isEmpty)
        #expect(try harness.store.pendingCookEntries(for: CookEntry.fixtureAccount).count == 2)
    }

    @Test func theNextAccountToSignInSendsOnlyItsOwnCooks() async throws {
        try harness.store.add(strangers)
        let api = ScriptedProgressAPI(ScriptedReply.accepting)
        await harness.upload(with: harness.uploader(api))
        #expect(await api.sent.isEmpty)
        #expect(try harness.store.pendingCookEntries(for: "another-cook") == [strangers])
    }
}
