/// Writes every answer of a profile into the stored fields. The id and the time belong to the store.
extension SavedProfile {
    public init(_ profile: CookProfile) {
        self.init()
        writeFood(of: profile)
        writeKitchen(of: profile)
        if let focusSkill = profile.focusSkill {
            self.focusSkill = focusSkill.rawValue
        }
        onboardingDone = profile.isOnboardingDone
    }

    private mutating func writeFood(of profile: CookProfile) {
        if let diet = profile.diet {
            self.diet = diet.rawValue
        }
        avoid = profile.avoid.savedIDs
        cuisinesLoved = profile.cuisinesLoved.savedIDs
        cuisinesToTry = profile.cuisinesToTry.savedIDs
        cuisinesNever = profile.cuisinesNever.savedIDs
        cupboardStaples = profile.cupboardStaples.savedIDs
    }

    private mutating func writeKitchen(of profile: CookProfile) {
        if let equipment = profile.equipment {
            self.equipment = equipment.savedIDs
        }
        experience = profile.experience.rawValue
        if let units = profile.units {
            self.units = units.rawValue
        }
        servings = profile.servings
        weeklyGoal = profile.weeklyGoal
    }
}
