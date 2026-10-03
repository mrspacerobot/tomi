import Testing

@testable import TomiCore

/// The streak follows the cook's own calendar: time zone, daylight saving and first weekday.
@Suite struct StreakCalendarTests {
    @Test func weeksChainAcrossTheEndOfDaylightSaving() {
        let london = StreakTestCalendar(timeZone: "Europe/London")
        let cooks = london.cooks(on: [.october(19), .october(25), .october(26), .november(1)])
        #expect(london.streak(cooks, on: .november(2)).weeks == 2)
    }

    @Test func aSundayStartPutsSundayInTheComingWeek() {
        let cooks = StreakTestCalendar().cooks(on: [.october(4), .october(5)])
        #expect(StreakTestCalendar(firstWeekday: 1).streak(cooks, on: .october(6)).daysThisWeek == 2)
        #expect(StreakTestCalendar(firstWeekday: 2).streak(cooks, on: .october(6)).daysThisWeek == 1)
    }

    @Test func theDaysLeftIncludeToday() {
        #expect(StreakTestCalendar().streak([], on: .october(5)).daysLeftInWeek == 7)
        #expect(StreakTestCalendar().streak([], on: .october(11)).daysLeftInWeek == 1)
    }

    @Test func aWeekIsAtRiskWhenEveryDayLeftIsNeeded() {
        let test = StreakTestCalendar()
        let streak = test.streak(test.cooks(on: [.october(5)]), goal: 3, on: .october(10))
        #expect(streak.isAtRisk)
        #expect(!streak.isLost)
    }

    @Test func aWeekIsLostWhenTooFewDaysAreLeft() {
        let test = StreakTestCalendar()
        let streak = test.streak(test.cooks(on: [.october(5)]), goal: 3, on: .october(11))
        #expect(streak.isLost)
        #expect(!streak.isAtRisk)
    }

    @Test func aMetWeekIsNeitherAtRiskNorLost() {
        let test = StreakTestCalendar()
        let streak = test.streak(test.cooks(on: [.october(10), .october(11)]), on: .october(11))
        #expect(streak.isThisWeekMet)
        #expect(!streak.isAtRisk && !streak.isLost)
    }
}
