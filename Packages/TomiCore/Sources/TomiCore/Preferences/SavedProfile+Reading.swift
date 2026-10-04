/// Reads a stored profile written by any version of the app, older or newer, by the rules of
/// `CookPreferences.init(from:)`: a missing field keeps its default, a value only a newer app knows falls back
/// to the default, and diet and avoid answers are kept as they are, so a restriction is never weakened.
extension SavedProfile {
    public var profile: CookProfile {
        var profile = CookProfile()
        profile.preferences = preferences
        if let focusSkill {
            profile.focusSkill = SkillID(rawValue: focusSkill)
        }
        profile.isOnboardingDone = onboardingDone ?? false
        return profile
    }

    var preferences: CookPreferences {
        var preferences = CookPreferences()
        readFood(into: &preferences)
        readKitchen(into: &preferences)
        readTable(into: &preferences)
        return preferences
    }

    /// Every saved diet and avoid id is kept, known or not and blank or not:
    /// the ingredient table refuses every dish for an id it does not list.
    private func readFood(into preferences: inout CookPreferences) {
        if let diet {
            preferences.diet = DietID(rawValue: diet)
        }
        preferences.avoid = Set(savedIDs: avoid)
        preferences.cuisines = savedCuisines
        preferences.cupboardStaples = Set(savedIDs: cupboardStaples)
    }

    private func readKitchen(into preferences: inout CookPreferences) {
        if let equipment {
            preferences.chosenEquipment = Set(savedIDs: equipment)
        }
        if let experience, let known = Experience(rawValue: experience) {
            preferences.experience = known
        }
        if let units {
            preferences.chosenUnits = Units(rawValue: units)
        }
    }

    private func readTable(into preferences: inout CookPreferences) {
        if let servings {
            preferences.setServings(servings)
        }
        if let weeklyGoal {
            preferences.setWeeklyGoal(weeklyGoal)
        }
    }

    /// A cuisine saved under two answers takes the one that offers it least: "never" before "love" before "try".
    private var savedCuisines: CuisinePreferences {
        var cuisines = CuisinePreferences()
        set(.try, for: cuisinesToTry, in: &cuisines)
        set(.love, for: cuisinesLoved, in: &cuisines)
        set(.never, for: cuisinesNever, in: &cuisines)
        return cuisines
    }

    private func set(_ preference: CuisinePreference, for saved: [String]?, in cuisines: inout CuisinePreferences) {
        let ids: Set<CuisineID> = Set(savedIDs: saved)
        for id in ids {
            cuisines.set(preference, for: id)
        }
    }
}
