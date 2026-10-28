import Foundation
import TomiCore

@testable import Tomi

/// One scripted answer to a request.
typealias ScriptedAnswer = @Sendable (CookEntryRequest) throws -> CookEntryResponse

/// A server for the uploader's tests. It answers each request as the test scripts it, the last answer for every
/// request after, keeps every request it was sent, and can hold an answer back until the test lets it go.
actor ScriptedProgressAPI {
    private(set) var sent: [CookEntryRequest] = []
    /// Each request as it arrives, before it is answered.
    let arrivals: AsyncStream<CookEntryRequest>
    private let arrivalSink: AsyncStream<CookEntryRequest>.Continuation
    private var replies: [ScriptedAnswer]
    private var holdsNextAnswer = false
    private var heldAnswer: CheckedContinuation<Void, Never>?

    /// When `holdingFirstAnswer`, the first request is kept waiting until `releaseAnswer()`.
    init(holdingFirstAnswer: Bool = false, _ replies: ScriptedAnswer...) {
        (arrivals, arrivalSink) = AsyncStream.makeStream(of: CookEntryRequest.self)
        self.replies = replies
        holdsNextAnswer = holdingFirstAnswer
    }

    func sendCookEntry(_ request: CookEntryRequest) async throws -> CookEntryResponse {
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
