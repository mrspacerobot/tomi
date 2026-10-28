import Foundation
import TomiCore

@testable import Tomi

actor HeldProgressAPI {
    let arrivals: AsyncStream<Void>
    private let arrivalSink: AsyncStream<Void>.Continuation
    private var held: CheckedContinuation<Void, Never>?

    init() { (arrivals, arrivalSink) = AsyncStream.makeStream(of: Void.self) }

    func progress(_ calendar: CalendarContext) async throws -> ProgressResponse {
        arrivalSink.yield(())
        await withCheckedContinuation { held = $0 }
        let body = try FakeProgressFixture.returning.body()
        return try ProgressResponse(reading: body)
    }

    func release() { held?.resume(); held = nil }

    func progress(_ calendar: CalendarContext, for account: String) async throws -> ProgressResponse {
        try await progress(calendar)
    }
}
