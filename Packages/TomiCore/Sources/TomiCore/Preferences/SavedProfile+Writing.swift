/// Writes every answer of a profile into the stored fields. The id and the time belong to the store.
extension SavedProfile {
    public init(_ profile: CookProfile) {
        self.init()
        writeFood(of: profile.preferences)
        writeKitchen(of: profile.preferences)
        if let focusSkill = profile.focusSkill {
            self.focusSkill = focusSkill.rawValue
        }
        onboardingDone = profile.isOnboardingDone
    }

    private mutating func writeFood(of preferences: CookPreferences) {
        if let diet = preferences.diet {
            self.diet = diet.rawValue
        }
        avoid = preferences.avoid.savedIDs
        cuisinesLoved = preferences.cuisines.cuisines(answered: .love).savedIDs
        cuisinesToTry = preferences.cuisines.cuisines(answered: .try).savedIDs
        cuisinesNever = preferences.cuisines.cuisines(answered: .never).savedIDs
        cupboardStaples = preferences.cupboardStaples.savedIDs
    }

    private mutating func writeKitchen(of preferences: CookPreferences) {
        if let chosenEquipment = preferences.chosenEquipment {
            equipment = chosenEquipment.savedIDs
        }
        experience = preferences.experience.rawValue
        if let chosenUnits = preferences.chosenUnits {
            units = chosenUnits.rawValue
        }
        servings = preferences.servings
        weeklyGoal = preferences.weeklyGoal
    }
}
