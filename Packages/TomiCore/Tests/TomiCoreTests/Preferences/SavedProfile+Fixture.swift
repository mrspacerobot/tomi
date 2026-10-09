import Foundation

@testable import TomiCore

extension SavedProfile {
    /// A stored copy with this weekly goal, changed on the given day of October.
    static func fixture(weeklyGoal: Int, changedOn day: Int) -> SavedProfile {
        var profile = CookProfile()
        profile.setWeeklyGoal(weeklyGoal)
        var saved = SavedProfile(profile)
        saved.stableID = UUID()
        saved.updatedAt = StreakTestCalendar().date(.october(day))
        return saved
    }
}

extension CookProfile {
    /// A profile with every answer changed from the defaults.
    static func fixtureWithEveryAnswerChanged() -> CookProfile {
        var profile = CookProfile()
        profile.diet = "vegetarian"
        profile.avoid = ["nuts", "sesame"]
        profile.cuisinesLoved = ["thai"]
        profile.cuisinesToTry = ["korean"]
        profile.cuisinesNever = ["british"]
        profile.cupboardStaples = ["salt", "olive-oil"]
        profile.equipment = ["oven"]
        profile.experience = .comfortable
        profile.setServings(4)
        profile.units = .cups
        profile.setWeeklyGoal(5)
        profile.focusSkill = "roux"
        profile.isOnboardingDone = true
        return profile
    }
}
