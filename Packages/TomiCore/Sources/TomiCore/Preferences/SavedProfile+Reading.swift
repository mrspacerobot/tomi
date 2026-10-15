/// Reads the stored copy of the profile, written by any version of the app, older or newer:
/// a missing field keeps its default and a value only a newer app knows falls back to the default.
/// The copy is a cache of the server's profile, so no answer here decides what the cook may eat.
extension SavedProfile {
    public var profile: CookProfile {
        var profile = CookProfile()
        readFood(into: &profile)
        readKitchen(into: &profile)
        readTable(into: &profile)
        if let focusSkill {
            profile.focusSkill = SkillID(rawValue: focusSkill)
        }
        profile.isOnboardingDone = onboardingDone ?? false
        return profile
    }

    private func readFood(into profile: inout CookProfile) {
        if let diet {
            profile.diet = OptionID(rawValue: diet)
        }
        profile.avoid = Set(savedIDs: avoid)
        profile.cuisinesLoved = Set(savedIDs: cuisinesLoved)
        profile.cuisinesToTry = Set(savedIDs: cuisinesToTry)
        profile.cuisinesNever = Set(savedIDs: cuisinesNever)
        profile.cupboardStaples = Set(savedIDs: cupboardStaples)
        profile.cupboardAnswered = cupboardAnswered ?? false
    }

    private func readKitchen(into profile: inout CookProfile) {
        if let equipment {
            profile.equipment = Set(savedIDs: equipment)
        }
        if let experience, let known = Experience(rawValue: experience) {
            profile.experience = known
        }
        if let units {
            profile.units = Units(rawValue: units)
        }
    }

    private func readTable(into profile: inout CookProfile) {
        if let servings {
            profile.setServings(servings)
        }
        if let weeklyGoal {
            profile.setWeeklyGoal(weeklyGoal)
        }
    }
}
