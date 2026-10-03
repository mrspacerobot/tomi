@testable import TomiCore

extension CookPreferences {
    /// Preferences with every answer different from its default, so a lost field shows in a test.
    static func fixtureWithEveryAnswerChanged() -> CookPreferences {
        var preferences = fixtureWithEveryFoodAnswerChanged()
        preferences.equipment = [.stovetop, .blender, .riceCooker]
        preferences.experience = .comfortable
        preferences.setServings(4)
        preferences.chosenUnits = .cups
        preferences.setWeeklyGoal(5)
        return preferences
    }

    private static func fixtureWithEveryFoodAnswerChanged() -> CookPreferences {
        var preferences = CookPreferences()
        preferences.diet = .pescatarian
        preferences.avoid = [.nuts, .pork]
        preferences.cuisines = .fixtureLovingItalianNeverThai()
        preferences.cupboardStaples = ["olive-oil", "salt"]
        return preferences
    }
}

extension CuisinePreferences {
    static func fixtureLovingItalianNeverThai() -> CuisinePreferences {
        var cuisines = CuisinePreferences()
        cuisines.set(.love, for: "italian")
        cuisines.set(.never, for: "thai")
        return cuisines
    }
}
