import Foundation
import Testing

@testable import TomiCore

/// One cook, to the store and back.
@Suite struct SavedCookEntryTests {
    @Test func aFinishedCookSurvivesBeingSavedAndReadBack() {
        let cook = CookEntry.fixture("knife", level: 2, on: .october(7))
        #expect(SavedCookEntry(cook).entry == cook)
    }

    @Test func aWrongQuizSurvivesToo() {
        let cook = CookEntry.fixture("knife").withTheQuizWrong()
        #expect(SavedCookEntry(cook).entry == cook)
    }

    @Test func aCookStoppedEarlySurvivesAndHasNoQuizAnswer() {
        let cook = CookEntry.fixture("knife").stoppedBeforeTheEnd()
        let saved = SavedCookEntry(cook)
        #expect(saved.quizCorrect == nil)
        #expect(saved.entry == cook)
    }

    @Test func everyFieldIsWrittenUnderItsOwnName() {
        let cook = CookEntry.fixture("knife", level: 2, on: .october(7)).with(weeklyGoal: 4)
        let saved = SavedCookEntry(cook)
        #expect(saved.stableID == cook.id)
        #expect(saved.lesson == "a-recipe")
        #expect(saved.skill == "knife")
        #expect(saved.level == 2)
        #expect(saved.date == TestCalendar().date(.october(7)))
        #expect(saved.stoppedEarly == false)
        #expect(saved.quizCorrect == true)
        #expect(saved.weeklyGoal == 4)
    }

    @Test func theGraphVersionOfARecipeIsWrittenWithIt() {
        #expect(SavedCookEntry(.fixture("knife")).graphVersion == "2026.10.20")
    }

    @Test func aSkillAndLevelUnknownHereAreKeptForTheRulesToJudge() {
        var saved = SavedCookEntry(.fixture("knife"))
        saved.skill = "sous-vide"
        saved.level = 9
        #expect(saved.entry?.lesson.skill == "sous-vide")
        #expect(saved.entry?.lesson.level == 9)
    }

    @Test func aFinishedCookWithoutAQuizAnswerEarnsTheCookAlone() {
        var saved = SavedCookEntry(.fixture("knife"))
        saved.quizCorrect = nil
        #expect(saved.entry?.session.result == .finished(quizCorrect: false))
    }

    @Test func aRecordWithNoFieldsIsNotAnEntry() {
        #expect(SavedCookEntry().entry == nil)
    }

    @Test(arguments: RequiredCookField.allCases)
    func aRecordThatLacksWhatAnEntryNeedsIsNotAnEntry(field: RequiredCookField) {
        let saved = SavedCookEntry(.fixture("knife")).without(field)
        #expect(saved.entry == nil)
    }
}
