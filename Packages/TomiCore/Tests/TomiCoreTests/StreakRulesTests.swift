import Testing

@testable import TomiCore

/// Weeks start on Monday: 2026-09-28, 2026-10-05 and so on. The goal is 2 cooking days unless a test says otherwise.
@Suite struct StreakRulesTests {
    let test = StreakTestCalendar()

    @Test func noCooksMeansNoStreak() {
        let streak = test.streak([], on: "2026-10-05")
        #expect(streak.weeks == 0)
        #expect(streak.daysThisWeek == 0)
    }

    @Test func consecutiveMetWeeksCount() {
        let cooks = test.cooks(["2026-09-21", "2026-09-23", "2026-09-28", "2026-10-02"])
        #expect(test.streak(cooks, on: "2026-10-05").weeks == 2)
    }

    @Test func aMissedWeekStartsTheCountAgain() {
        let cooks = test.cooks(["2026-09-14", "2026-09-15", "2026-09-21", "2026-09-28", "2026-10-02"])
        #expect(test.streak(cooks, on: "2026-10-05").weeks == 1)
    }

    @Test func theWeekInProgressAddsOnlyOnceItsGoalIsMet() {
        let lastWeek = test.cooks(["2026-09-28", "2026-10-02"])
        #expect(test.streak(lastWeek + test.cooks(["2026-10-05"]), on: "2026-10-06").weeks == 1)
        #expect(test.streak(lastWeek + test.cooks(["2026-10-05", "2026-10-06"]), on: "2026-10-06").weeks == 2)
    }

    @Test func severalCooksOnOneDayCountAsOneDay() {
        let cooks = [test.date("2026-10-05", hour: 9), test.date("2026-10-05", hour: 19)]
            .map { CompletedCook(date: $0, weeklyGoal: 2) }
        let streak = test.streak(cooks, on: "2026-10-06")
        #expect(streak.daysThisWeek == 1)
        #expect(!streak.isThisWeekMet)
    }

    @Test func aPastWeekIsJudgedByTheGoalRecordedThatWeek() {
        let cooks = test.cooks(["2026-09-28", "2026-10-02"], goal: 2)
        #expect(test.streak(cooks, goal: 5, on: "2026-10-05").weeks == 1)
    }
}
