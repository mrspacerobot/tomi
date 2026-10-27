import Foundation
import Testing

@testable import TomiCore

/// An older snapshot never replaces a newer one, whatever order the answers arrive in.
@Suite struct SnapshotKeepingTests {
    func body(computedAt moment: String) -> Data {
        Data(ProgressJSON.snapshot(setting: ["computedAt"], to: moment).utf8)
    }

    func snapshot(computedAt moment: String) throws -> ProgressSnapshot {
        try JSONDecoder().decode(ProgressSnapshot.self, from: body(computedAt: moment))
    }

    @Test func aSnapshotIsKeptWhenNothingIsKept() {
        #expect(SnapshotKeeping.shouldKeep(body(computedAt: "2026-10-27T18:43:02Z"), over: nil))
    }

    @Test func aNewerSnapshotReplacesTheKeptOne() throws {
        let kept = try snapshot(computedAt: "2026-10-27T18:43:02Z")
        #expect(SnapshotKeeping.shouldKeep(body(computedAt: "2026-10-27T18:43:03Z"), over: kept))
    }

    @Test func aSnapshotOfTheSameMomentIsKeptAgain() throws {
        let kept = try snapshot(computedAt: "2026-10-27T18:43:02Z")
        #expect(SnapshotKeeping.shouldKeep(body(computedAt: "2026-10-27T18:43:02Z"), over: kept))
    }

    @Test func anOlderSnapshotNeverReplacesTheKeptOne() throws {
        let kept = try snapshot(computedAt: "2026-10-27T18:43:02Z")
        #expect(!SnapshotKeeping.shouldKeep(body(computedAt: "2026-10-27T18:43:01Z"), over: kept))
    }

    @Test func aBodyThatCannotBeReadIsNeverKept() throws {
        let kept = try snapshot(computedAt: "2026-10-27T18:43:02Z")
        #expect(!SnapshotKeeping.shouldKeep(Data("{}".utf8), over: kept))
        #expect(!SnapshotKeeping.shouldKeep(Data("{}".utf8), over: nil))
    }
}
