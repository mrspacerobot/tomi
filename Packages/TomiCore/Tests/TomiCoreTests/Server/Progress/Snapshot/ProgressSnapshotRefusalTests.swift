import Foundation
import Testing

@testable import TomiCore

/// A snapshot the app cannot read in full is refused, never shown as zero or as a guess.
@Suite struct ProgressSnapshotRefusalTests {
    func expectRefused(_ text: String) {
        #expect(text != ProgressJSON.snapshot)
        #expect(throws: (any Error).self) {
            try ServerJSON.decode(ProgressSnapshot.self, from: text)
        }
    }

    @Test func anUnknownSchemaVersionIsRefusedBeforeAnythingElseIsRead() throws {
        let newerLayout = ProgressJSON.snapshot(setting: ["schemaVersion"], to: 2)
        let text = ProgressJSON.removing(["xp"], from: newerLayout)
        #expect(text != newerLayout)
        #expect(throws: ProgressSnapshotError.unsupportedSchemaVersion(2)) {
            try ServerJSON.decode(ProgressSnapshot.self, from: text)
        }
    }

    @Test func aSnapshotWithoutASchemaVersionIsRefused() {
        expectRefused(ProgressJSON.snapshot(removing: ["schemaVersion"]))
    }

    @Test func aSnapshotWithoutXPIsRefused() {
        expectRefused(ProgressJSON.snapshot(removing: ["xp"]))
    }

    @Test func aRankWithoutTheXPItStartsAtIsRefused() {
        expectRefused(ProgressJSON.snapshot(removing: ["rank", "startsAt"]))
    }

    @Test func aRankWithoutTheXPOfTheNextRankIsRefused() {
        expectRefused(ProgressJSON.snapshot(removing: ["rank", "nextAt"]))
    }

    @Test func aLevelWithoutTheCooksToCompleteItIsRefused() {
        expectRefused(ProgressJSON.snapshot(removing: ["skills", 0, "levels", 0, "cooksToComplete"]))
    }

    @Test func aSkillWithAnUnknownStatusIsRefused() {
        expectRefused(ProgressJSON.snapshot(setting: ["skills", 0, "status"], to: "glazed"))
    }

    @Test func aSnapshotWithoutItsCalendarIsRefused() {
        expectRefused(ProgressJSON.snapshot(removing: ["calendar"]))
    }

    @Test func anInstantThatIsNotAnRFC3339InstantIsRefused() {
        expectRefused(ProgressJSON.snapshot(setting: ["computedAt"], to: "26 October 2026"))
    }
}
