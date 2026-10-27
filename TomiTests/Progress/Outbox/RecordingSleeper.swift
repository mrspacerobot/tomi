import Foundation

@testable import Tomi

/// The uploader's timer in tests: it keeps every wait asked of it, in order, and lets only as many end as the test
/// allows. Every later wait never ends, as if the test were over before its time came. No clock is read.
@MainActor
final class RecordingSleeper: Sleeper {
    /// Every wait asked for, as it is asked.
    let requests: AsyncStream<Duration>
    private let sink: AsyncStream<Duration>.Continuation
    private var wakesLeft: Int

    init(wakes: Int = 0) {
        (requests, sink) = AsyncStream.makeStream(of: Duration.self)
        wakesLeft = wakes
    }

    func sleep(for duration: Duration) async throws {
        sink.yield(duration)
        guard wakesLeft > 0 else {
            throw CancellationError()
        }
        wakesLeft -= 1
    }
}
