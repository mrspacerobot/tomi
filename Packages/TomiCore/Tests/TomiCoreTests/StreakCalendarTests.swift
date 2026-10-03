import Testing

@testable import TomiCore

/// The streak follows the cook's own calendar: time zone, daylight saving and first weekday.
@Suite struct StreakCalendarTests {
    @Test func weeksChainAcrossTheEndOfDaylightSaving() {
        let london = StreakTestCalendar(timeZone: "Europe/London")
        let cooks = london.cooks(["2026-10-19", "2026-10-25", "2026-10-26", "2026-11-01"])
        #expect(london.streak(cooks, on: "2026-11-02").weeks == 2)
    }

    @Test func aSundayStartPutsSundayInTheComingWeek() {
        let cooks = StreakTestCalendar().cooks(["2026-10-04", "2026-10-05"])
        #expect(StreakTestCalendar(firstWeekday: 1).streak(cooks, on: "2026-10-06").daysThisWeek == 2)
        #expect(StreakTestCalendar(firstWeekday: 2).streak(cooks, on: "2026-10-06").daysThisWeek == 1)
    }

    @Test func theDaysLeftIncludeToday() {
        #expect(StreakTestCalendar().streak([], on: "2026-10-05").daysLeftInWeek == 7)
        #expect(StreakTestCalendar().streak([], on: "2026-10-11").daysLeftInWeek == 1)
    }

    @Test func aWeekIsAtRiskWhenEveryDayLeftIsNeeded() {
        let test = StreakTestCalendar()
        let streak = test.streak(test.cooks(["2026-10-05"]), goal: 3, on: "2026-10-10")
        #expect(streak.isAtRisk)
        #expect(!streak.isLost)
    }

    @Test func aWeekIsLostWhenTooFewDaysAreLeft() {
        let test = StreakTestCalendar()
        let streak = test.streak(test.cooks(["2026-10-05"]), goal: 3, on: "2026-10-11")
        #expect(streak.isLost)
        #expect(!streak.isAtRisk)
    }

    @Test func aMetWeekIsNeitherAtRiskNorLost() {
        let test = StreakTestCalendar()
        let streak = test.streak(test.cooks(["2026-10-10", "2026-10-11"]), on: "2026-10-11")
        #expect(streak.isThisWeekMet)
        #expect(!streak.isAtRisk && !streak.isLost)
    }
}
