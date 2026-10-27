import Testing

@testable import TomiCore

/// When the outbox is sent again after each kind of failure. The upload service only carries this out.
@Suite struct OutboxWaitTests {
    @Test func aBatchTheServerCannotReadWaitsForTheNextLaunch() {
        #expect(CookOutbox.wait(after: .batchUnreadable) == .untilLaunch)
    }

    @Test func nobodySignedInWaitsForTheNextSignIn() {
        #expect(CookOutbox.wait(after: .notSignedIn) == .untilSignIn)
    }

    @Test func anyOtherFailureTriesAgainWithBackoff() {
        #expect(CookOutbox.wait(after: .other) == .withBackoff)
    }
}
