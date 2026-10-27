import Testing

@testable import TomiCore

/// The weekly goal stays a number of days one week can hold, whatever is asked for.
@Suite struct CookProfileWeeklyGoalTests {
    @Test func aNewCookAimsForTheServersDefault() {
        #expect(CookProfile().weeklyGoal == CookProfile.defaultWeeklyGoal)
        #expect(CookProfile.weeklyGoalRange.contains(CookProfile.defaultWeeklyGoal))
    }

    @Test func aGoalOutsideTheWeekIsBroughtBackIn() {
        var profile = CookProfile()
        profile.setWeeklyGoal(0)
        #expect(profile.weeklyGoal == 1)
        profile.setWeeklyGoal(8)
        #expect(profile.weeklyGoal == 7)
    }

    @Test func everyGoalInsideTheWeekIsKept() {
        var profile = CookProfile()
        for goal in CookProfile.weeklyGoalRange {
            profile.setWeeklyGoal(goal)
            #expect(profile.weeklyGoal == goal)
        }
    }
}
