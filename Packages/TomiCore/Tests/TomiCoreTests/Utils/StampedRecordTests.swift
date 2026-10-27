import Foundation
import Testing

@testable import TomiCore

/// Picking the newest of several saved records, the same way whatever order they come in.
@Suite struct StampedRecordTests {
    let monday = SavedActiveLesson.stamped(on: .october(5))
    let tuesday = SavedActiveLesson.stamped(on: .october(6))

    @Test func noRecordsHaveNoNewest() {
        let none: [SavedActiveLesson] = []
        #expect(none.newest == nil)
    }

    @Test func theRecordChangedLastIsTheNewestInEitherOrder() {
        #expect([monday, tuesday].newest == tuesday)
        #expect([tuesday, monday].newest == tuesday)
    }

    @Test func aRecordWithoutATimeIsOlderThanOneWithATime() {
        var undated = tuesday
        undated.updatedAt = nil
        #expect([undated, monday].newest == monday)
        #expect([monday, undated].newest == monday)
    }

    @Test func recordsOfTheSameMomentAreOrderedByTheirIds() {
        let other = SavedActiveLesson.stamped(on: .october(5))
        #expect([monday, other].newest == [other, monday].newest)
    }

    @Test func aRecordIsNotNewerThanItself() {
        #expect(!monday.isNewer(than: monday))
    }

    @Test func identicalCopiesStillHaveOneNewestRecord() {
        #expect([monday, monday].newest == monday)
    }

    @Test func conflictingCopiesWithTheSameStampHaveNoUnambiguousNewest() {
        var different = monday
        different.currentStep = 2
        #expect([monday, different].newest == nil)
        #expect([different, monday].newest == nil)
    }
}

extension SavedActiveLesson {
    fileprivate static func stamped(on day: DateComponents) -> SavedActiveLesson {
        var saved = SavedActiveLesson()
        saved.stableID = UUID()
        saved.updatedAt = TestCalendar().date(day)
        return saved
    }
}
