import Foundation
import Testing

@testable import TomiCore

/// The answer to `POST /v1/cook-entries` as it arrived: read, and with the snapshot's own JSON kept for the store.
@Suite struct CookEntriesResponseTests {
    static let results = #"[{"id": "4e2c2a0e-7e6b-4c7a-9c2b-6e0a3d1f9a11", "status": "accepted"}]"#

    func response(progress: String) throws -> CookEntriesResponse {
        let text = #"{"results": "# + Self.results + #", "progress": "# + progress + "}"
        return try CookEntriesResponse(reading: Data(text.utf8))
    }

    @Test func theSnapshotIsKeptAsTheServerSentIt() throws {
        let response = try response(progress: ProgressJSON.snapshot)
        let body = try #require(response.snapshotBody)
        #expect(try ProgressJSON.object(of: body) == (try ProgressJSON.object(of: Data(ProgressJSON.snapshot.utf8))))
        #expect(try JSONDecoder().decode(ProgressSnapshot.self, from: body) == response.answer.progress)
        #expect(response.answer.results.map(\.status) == [.accepted])
    }

    /// A field a newer server adds is kept too, so the store holds everything that was sent.
    @Test func aFieldANewerServerAddsIsKept() throws {
        let newer = ProgressJSON.snapshot(replacing: #""rulesVersion": 1,"#, with: #""rulesVersion": 1, "next": [2],"#)
        #expect(newer != ProgressJSON.snapshot)
        let body = try #require(try response(progress: newer).snapshotBody)
        #expect(try ProgressJSON.object(of: body)["next"] as? [Int] == [2])
    }

    /// A snapshot this app cannot read is never kept, so it never replaces the last one that could be.
    @Test func aSnapshotThatCannotBeReadIsNotKept() throws {
        let unknown = ProgressJSON.snapshot(replacing: #""schemaVersion": 1"#, with: #""schemaVersion": 99"#)
        #expect(unknown != ProgressJSON.snapshot)
        let response = try response(progress: unknown)
        #expect(response.snapshotBody == nil)
        #expect(response.answer.results.count == 1)
    }

    @Test func anAnswerWithoutASnapshotKeepsNone() throws {
        let text = #"{"results": "# + Self.results + "}"
        #expect(try CookEntriesResponse(reading: Data(text.utf8)).snapshotBody == nil)
    }

    @Test func anAnswerWhoseResultsCannotBeReadIsRefused() {
        #expect(throws: (any Error).self) {
            try CookEntriesResponse(reading: Data(#"{"progress": {}}"#.utf8))
        }
    }
}
