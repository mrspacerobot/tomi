import Testing

@testable import TomiCore

/// The cook log feeds the streak rules, so one log is the input for every rule.
@Suite struct CookLogStreakTests {
    let test = StreakTestCalendar()

    @Test func aFinishedEntryBecomesACompletedCookWithItsDateAndGoal() {
        let entry = CookEntry.fixture("knife", on: .october(2)).with(weeklyGoal: 4)
        #expect([entry].completedCooks == [CompletedCook(date: test.date(.october(2)), weeklyGoal: 4)])
    }

    @Test func anEntryStoppedEarlyIsNotACompletedCook() {
        let entry = CookEntry.fixture("knife").stoppedBeforeTheEnd()
        #expect([entry].completedCooks.isEmpty)
    }

    @Test func theSameEntryTwiceIsOneCompletedCook() {
        let entry = CookEntry.fixture("knife")
        #expect([entry, entry].completedCooks.count == 1)
    }

    @Test func entriesTheCatalogDoesNotKnowStillCountForTheStreak() {
        #expect([CookEntry.fixture("sous-vide", level: 9)].completedCooks.count == 1)
    }

    @Test func theStreakIsCountedFromTheLog() {
        let lastWeek: [CookEntry] = [.fixture("knife", on: .september(28)), .fixture("eggs", on: .october(2))]
        let abandoned = CookEntry.fixture("knife", on: .october(6)).stoppedBeforeTheEnd()
        let thisWeek: [CookEntry] = [.fixture("knife", on: .october(5)), abandoned]
        let streak = test.streak((lastWeek + thisWeek).completedCooks, on: .october(6))
        #expect(streak.weeks == 1)
        #expect(streak.daysThisWeek == 1)
    }
}
