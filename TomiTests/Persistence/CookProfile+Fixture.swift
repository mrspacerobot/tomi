import TomiCore

extension CookProfile {
    /// A profile with every answer different from its default, so a lost field shows in a test.
    static func fixtureWithEveryAnswerChanged() -> CookProfile {
        var profile = CookProfile()
        profile.preferences = .fixtureWithEveryAnswerChanged()
        profile.focusSkill = "roux"
        profile.isOnboardingDone = true
        return profile
    }

    static func fixture(diet: DietID?, avoid: Set<AvoidItemID> = []) -> CookProfile {
        var profile = CookProfile()
        profile.preferences.diet = diet
        profile.preferences.avoid = avoid
        return profile
    }
}

extension CookPreferences {
    static func fixtureWithEveryAnswerChanged() -> CookPreferences {
        var preferences = CookPreferences()
        preferences.diet = "pescatarian"
        preferences.avoid = ["nuts", "pork"]
        preferences.cuisines.set(.love, for: "italian")
        preferences.cuisines.set(.never, for: "thai")
        preferences.cupboardStaples = ["olive-oil", "salt"]
        preferences.changeKitchenAnswers()
        return preferences
    }

    private mutating func changeKitchenAnswers() {
        chosenEquipment = ["stovetop", "blender"]
        experience = .comfortable
        setServings(4)
        chosenUnits = .cups
        setWeeklyGoal(5)
    }
}
