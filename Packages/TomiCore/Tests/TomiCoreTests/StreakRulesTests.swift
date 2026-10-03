import Testing

@testable import TomiCore

/// Weeks start on Monday, for example 5 October. The goal is 2 cooking days unless a test says otherwise.
@Suite struct StreakRulesTests {
    let test = StreakTestCalendar()

    @Test func noCooksMeansNoStreak() {
        let streak = test.streak([], on: .october(5))
        #expect(streak.weeks == 0)
        #expect(streak.daysThisWeek == 0)
    }

    @Test func consecutiveMetWeeksCount() {
        let cooks = test.cooks(on: [.september(21), .september(23), .september(28), .october(2)])
        #expect(test.streak(cooks, on: .october(5)).weeks == 2)
    }

    @Test func aMissedWeekStartsTheCountAgain() {
        let cooks = test.cooks(on: [.september(14), .september(15), .september(21), .september(28), .october(2)])
        #expect(test.streak(cooks, on: .october(5)).weeks == 1)
    }

    @Test func theWeekInProgressAddsOnlyOnceItsGoalIsMet() {
        let lastWeek = test.cooks(on: [.september(28), .october(2)])
        #expect(test.streak(lastWeek + test.cooks(on: [.october(5)]), on: .october(6)).weeks == 1)
        #expect(test.streak(lastWeek + test.cooks(on: [.october(5), .october(6)]), on: .october(6)).weeks == 2)
    }

    @Test func severalCooksOnOneDayCountAsOneDay() {
        let cooks = [test.date(.october(5), hour: 9), test.date(.october(5), hour: 19)]
            .map { CompletedCook(date: $0, weeklyGoal: 2) }
        let streak = test.streak(cooks, on: .october(6))
        #expect(streak.daysThisWeek == 1)
        #expect(!streak.isThisWeekMet)
    }

    @Test func aPastWeekIsJudgedByTheGoalRecordedThatWeek() {
        let cooks = test.cooks(on: [.september(28), .october(2)], goal: 2)
        #expect(test.streak(cooks, goal: 5, on: .october(5)).weeks == 1)
    }

    @Test func aWeeksGoalIsTheOneFromItsLatestCookInAnyOrder() {
        let laterWithGoalTwo = test.cooks(on: [.october(2)], goal: 2)
        let earlierWithGoalFive = test.cooks(on: [.september(28)], goal: 5)
        #expect(test.streak(laterWithGoalTwo + earlierWithGoalFive, on: .october(5)).weeks == 1)
        #expect(test.streak(earlierWithGoalFive + laterWithGoalTwo, on: .october(5)).weeks == 1)
    }
}
