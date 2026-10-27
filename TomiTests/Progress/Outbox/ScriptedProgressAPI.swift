import Foundation
import TomiCore

@testable import Tomi

/// One scripted answer to a batch.
typealias ScriptedAnswer = @Sendable (CookEntriesRequest) throws -> CookEntriesResponse

/// A server for the uploader's tests. It answers each batch as the test scripts it, the last answer for every batch
/// after, keeps every batch it was sent, and can hold an answer back until the test lets it go.
actor ScriptedProgressAPI {
    private(set) var sent: [CookEntriesRequest] = []
    /// Each batch as it arrives, before it is answered.
    let arrivals: AsyncStream<CookEntriesRequest>
    private let arrivalSink: AsyncStream<CookEntriesRequest>.Continuation
    private var replies: [ScriptedAnswer]
    private var holdsNextAnswer = false
    private var heldAnswer: CheckedContinuation<Void, Never>?

    /// When `holdingFirstAnswer`, the first batch is kept waiting until `releaseAnswer()`.
    init(holdingFirstAnswer: Bool = false, _ replies: ScriptedAnswer...) {
        (arrivals, arrivalSink) = AsyncStream.makeStream(of: CookEntriesRequest.self)
        self.replies = replies
        holdsNextAnswer = holdingFirstAnswer
    }

    func sendCookEntries(_ request: CookEntriesRequest) async throws -> CookEntriesResponse {
        sent.append(request)
        arrivalSink.yield(request)
        if holdsNextAnswer {
            holdsNextAnswer = false
            await withCheckedContinuation { heldAnswer = $0 }
        }
        return try nextAnswer()(request)
    }

    func releaseAnswer() {
        heldAnswer?.resume()
        heldAnswer = nil
    }

    private func nextAnswer() -> ScriptedAnswer {
        if replies.count > 1 {
            return replies.removeFirst()
        }
        guard let last = replies.first else {
            return ScriptedReply.failing(.unreachable)
        }
        return last
    }
}
