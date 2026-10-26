import Foundation
import Testing

@testable import TomiCore

/// A snapshot the app cannot read in full is refused, never shown as zero or as a guess.
@Suite struct ProgressSnapshotRefusalTests {
    func expectRefused(replacing old: String, with new: String = "") {
        let text = ProgressJSON.snapshot(replacing: old, with: new)
        #expect(text != ProgressJSON.snapshot)
        #expect(throws: (any Error).self) {
            try ServerJSON.decode(ProgressSnapshot.self, from: text)
        }
    }

    @Test func anUnknownSchemaVersionIsRefusedBeforeAnythingElseIsRead() {
        let newerLayout = ProgressJSON.snapshot(replacing: #""schemaVersion": 1,"#, with: #""schemaVersion": 2,"#)
        let text = newerLayout.replacingOccurrences(of: #""xp": 360,"#, with: "")
        #expect(newerLayout != ProgressJSON.snapshot)
        #expect(text != newerLayout)
        #expect(throws: ProgressSnapshotError.unsupportedSchemaVersion(2)) {
            try ServerJSON.decode(ProgressSnapshot.self, from: text)
        }
    }

    @Test func aSnapshotWithoutASchemaVersionIsRefused() {
        expectRefused(replacing: #""schemaVersion": 1,"#)
    }

    @Test func aSnapshotWithoutXPIsRefused() {
        expectRefused(replacing: #""xp": 360,"#)
    }

    @Test func aRankWithoutTheXPItStartsAtIsRefused() {
        expectRefused(replacing: #""startsAt": 150, "#)
    }

    @Test func aRankWithoutTheXPOfTheNextRankIsRefused() {
        expectRefused(replacing: #", "nextAt": 400"#)
    }

    @Test func aLevelWithoutTheCooksToCompleteItIsRefused() {
        expectRefused(replacing: #""cooksToComplete": 2, "#)
    }

    @Test func aSkillWithAnUnknownStatusIsRefused() {
        expectRefused(replacing: #""status": "mastered""#, with: #""status": "glazed""#)
    }

    @Test func aSnapshotWithoutItsCalendarIsRefused() {
        expectRefused(replacing: #""calendar": { "timeZone": "Europe/Amsterdam", "firstWeekday": 2 },"#)
    }

    @Test func anInstantThatIsNotAnRFC3339InstantIsRefused() {
        expectRefused(replacing: #""2026-10-26T18:43:02Z""#, with: #""26 October 2026""#)
    }
}
