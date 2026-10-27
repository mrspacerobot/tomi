import Foundation
import Testing

@testable import TomiCore

/// `GET /v1/progress` is read, and its JSON kept exactly as it arrived for the store.
@Suite struct ProgressResponseTests {
    @Test func theSnapshotIsReadAndItsBytesAreKeptAsSent() throws {
        let body = Data(ProgressJSON.snapshot.utf8)
        let response = try ProgressResponse(reading: body)
        #expect(response.snapshot == (try ServerJSON.decode(ProgressSnapshot.self, from: ProgressJSON.snapshot)))
        #expect(response.body == body)
    }

    @Test func aSnapshotThatCannotBeReadIsRefused() {
        #expect(throws: (any Error).self) { try ProgressResponse(reading: Data("{}".utf8)) }
    }
}
