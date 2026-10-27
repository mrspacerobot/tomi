import Foundation
import Testing

@testable import TomiCore

/// The answer for the cook entry that was sent. Whatever the app does not know keeps the entry for another try.
@Suite struct CookEntryResultTests {
    func result(_ text: String) throws -> CookEntryResult {
        try ServerJSON.decode(CookEntryResult.self, from: text)
    }

    @Test func everyKnownStatusIsRead() throws {
        let id = #""id": "4e2c2a0e-7e6b-4c7a-9c2b-6e0a3d1f9a11""#
        #expect(try result(#"{\#(id), "status": "accepted"}"#).status == .accepted)
        #expect(try result(#"{\#(id), "status": "duplicate"}"#).status == .duplicate)
        #expect(try result(#"{\#(id), "status": "conflict"}"#).status == .conflict)
        #expect(try result(#"{\#(id), "status": "rejected", "problems": ["unknown_field"]}"#).status == .rejected)
    }

    @Test func anUnknownStatusReadsAsKeepAndRetry() throws {
        let read = try result(#"{"id": "4e2c2a0e-7e6b-4c7a-9c2b-6e0a3d1f9a11", "status": "parked"}"#)
        #expect(read.status == .unknown("parked"))
        #expect(read.status.keepsTheEntry)
    }

    @Test func onlyAnUnknownStatusKeepsTheEntryAsItIs() {
        let known: [CookEntryStatus] = [.accepted, .duplicate, .conflict, .rejected]
        #expect(known.allSatisfy { !$0.keepsTheEntry })
    }

    @Test func anEntryWithoutAReadableIDIsAnsweredWithoutOne() throws {
        let read = try result(#"{"id": null, "status": "rejected", "problems": ["unreadable_entry"]}"#)
        #expect(read.id == nil)
        #expect(read.problems == ["unreadable_entry"])
    }

    @Test func anAnswerCarryingTheSnapshotReadsIt() throws {
        let text = #"{"result": {"id": null, "status": "accepted"}, "progress": \#(ProgressJSON.snapshot)}"#
        let answer = try ServerJSON.decode(CookEntryAnswer.self, from: text)
        #expect(answer.progress?.xp == 350)
    }

    /// The acknowledgement matters more than the snapshot: a snapshot that cannot be read is left out,
    /// never shown as zero, and the result is still read so the cook is not sent again for nothing.
    @Test func anUnreadableSnapshotLeavesTheResultReadable() throws {
        let result = #"{"id": "4e2c2a0e-7e6b-4c7a-9c2b-6e0a3d1f9a11", "status": "accepted"}"#
        let answer = try ServerJSON.decode(
            CookEntryAnswer.self,
            from: #"{"result": \#(result), "progress": {"schemaVersion": 9}}"#
        )
        #expect(answer.result.status == .accepted)
        #expect(answer.progress == nil)
    }
}
