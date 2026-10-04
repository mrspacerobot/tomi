import Foundation
import Testing
import TomiCore

@testable import Tomi

/// The stored records copy every field to and from the plain values TomiCore reads, and lose none.
@MainActor
@Suite struct StoredRecordTests {
    @Test func aNewProfileRecordHasNoFields() {
        #expect(ProfileRecord().saved == SavedProfile())
    }

    @Test func aProfileRecordKeepsEveryAnswer() {
        let saved = SavedProfile(.fixtureWithEveryAnswerChanged())
        let record = ProfileRecord()
        record.write(saved)
        #expect(record.saved == saved)
    }

    @Test func writingAnswersLeavesTheIdAndTheTimeOfAProfileRecordAlone() {
        let record = ProfileRecord()
        let id = UUID()
        record.stableID = id
        record.updatedAt = .october(5)
        record.write(SavedProfile(.fixtureWithEveryAnswerChanged()))
        #expect(record.saved.stableID == id)
        #expect(record.saved.updatedAt == .october(5))
    }

    @Test func writingADefaultProfileClearsTheAnswersThatWereThere() {
        let record = ProfileRecord()
        record.write(SavedProfile(.fixtureWithEveryAnswerChanged()))
        record.write(SavedProfile(CookProfile()))
        #expect(record.saved == SavedProfile(CookProfile()))
        #expect(record.diet == nil)
        #expect(record.equipment == nil)
    }

    @Test func aCookRecordKeepsEveryField() {
        let saved = SavedCookEntry(.fixture("eggs", onOctober: 5))
        #expect(CookLogRecord(saved).saved == saved)
    }

    @Test func aCookRecordMadeFromNothingHasNoFields() {
        #expect(CookLogRecord(SavedCookEntry()).saved == SavedCookEntry())
    }

    @Test func aBookmarkRecordKeepsEveryField() {
        let saved = SavedActiveLesson(.fixture("an-omelette", onStep: 3))
        let record = ActiveLessonRecord()
        record.write(saved)
        #expect(record.saved == saved)
        #expect(ActiveLessonRecord().saved == SavedActiveLesson())
    }
}
