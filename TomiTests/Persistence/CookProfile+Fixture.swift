import TomiCore

extension CookProfile {
    /// A profile with every answer different from its default, so a lost field shows in a test.
    static func fixtureWithEveryAnswerChanged() -> CookProfile {
        var profile = CookProfile()
        profile.diet = "pescatarian"
        profile.avoid = ["nuts", "pork"]
        profile.cuisinesLoved = ["italian"]
        profile.cuisinesNever = ["thai"]
        profile.cupboardStaples = ["olive-oil", "salt"]
        profile.changeKitchenAnswers()
        profile.focusSkill = "roux"
        profile.isOnboardingDone = true
        return profile
    }

    static func fixture(diet: OptionID?, avoid: Set<OptionID> = []) -> CookProfile {
        var profile = CookProfile()
        profile.diet = diet
        profile.avoid = avoid
        return profile
    }

    private mutating func changeKitchenAnswers() {
        equipment = ["stovetop", "blender"]
        experience = .comfortable
        setServings(4)
        units = .cups
        setWeeklyGoal(5)
    }
}
