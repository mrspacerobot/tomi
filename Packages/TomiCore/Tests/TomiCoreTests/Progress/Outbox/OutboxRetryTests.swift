import Testing

@testable import TomiCore

/// How long to wait before sending the outbox again. Worked out from the failed tries so far, never the clock.
@Suite struct OutboxRetryTests {
    @Test func theFirstRetryWaitsTwoSeconds() {
        #expect(CookOutbox.retryDelay(afterFailedAttempts: 1) == .seconds(2))
    }

    @Test func eachFailureDoublesTheWait() {
        let delays = (1...6).map { CookOutbox.retryDelay(afterFailedAttempts: $0) }
        #expect(delays == [.seconds(2), .seconds(4), .seconds(8), .seconds(16), .seconds(32), .seconds(64)])
    }

    @Test func theWaitStopsGrowingAtFifteenMinutes() {
        #expect(CookOutbox.retryDelay(afterFailedAttempts: 9) == .seconds(512))
        #expect(CookOutbox.retryDelay(afterFailedAttempts: 10) == .seconds(15 * 60))
        #expect(CookOutbox.retryDelay(afterFailedAttempts: 11) == .seconds(15 * 60))
        #expect(CookOutbox.retryDelay(afterFailedAttempts: 10_000) == .seconds(15 * 60))
        #expect(CookOutbox.retryDelay(afterFailedAttempts: Int.max) == .seconds(15 * 60))
    }

    @Test func withoutAFailureThereIsNoWait() {
        #expect(CookOutbox.retryDelay(afterFailedAttempts: 0) == .zero)
        #expect(CookOutbox.retryDelay(afterFailedAttempts: -3) == .zero)
    }
}
