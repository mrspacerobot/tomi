import Foundation
import Testing

@testable import TomiCore

/// An instant is read exactly as written. Text that only looks like one is refused, so a snapshot never shows a
/// moment the server did not send.
@Suite struct ServerInstantTests {
    func read(_ text: String) throws -> ServerInstant {
        try ServerJSON.decode(ServerInstant.self, from: "\"" + text + "\"")
    }

    @Test func anInstantIsReadToTheSecond() throws {
        let expected = UTCMoment().date(.october(26), hour: 18, minute: 43, second: 2)
        #expect(try read("2026-10-26T18:43:02Z").date == expected)
    }

    @Test func fractionalSecondsAreReadToo() throws {
        let expected = UTCMoment().date(.october(26), hour: 18, minute: 43, second: 2)
        let read = try read("2026-10-26T18:43:02.250Z").date
        #expect(abs(read.timeIntervalSince(expected) - 0.25) < 0.001)
    }

    @Test(arguments: [
        "2026-02-30T18:43:02Z", "2026-13-01T18:43:02Z", "2026-10-26T25:00:00Z",
        "2026-10-26T18:43:02Zgarbage", " 2026-10-26T18:43:02Z", "2026-10-26T18:43:02",
        "2026-10-26T18:43:02+01:00", "26 October 2026", "",
    ])
    func textThatIsNotExactlyAnInstantIsRefused(text: String) {
        #expect(throws: (any Error).self) { try read(text) }
    }
}
