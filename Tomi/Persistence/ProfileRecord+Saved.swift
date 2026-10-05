import TomiCore

/// Copies the stored fields to and from the plain value TomiCore reads. No rule lives here.
extension ProfileRecord {
    var saved: SavedProfile {
        var saved = SavedProfile()
        saved.stableID = stableID
        saved.updatedAt = updatedAt
        readFood(into: &saved)
        readKitchen(into: &saved)
        return saved
    }

    /// Takes every answer. The id and the time belong to the store and are left as they are.
    func write(_ saved: SavedProfile) {
        writeFood(of: saved)
        writeKitchen(of: saved)
    }

    private func readFood(into saved: inout SavedProfile) {
        saved.diet = diet
        saved.avoid = avoid
        saved.cuisinesLoved = cuisinesLoved
        saved.cuisinesToTry = cuisinesToTry
        saved.cuisinesNever = cuisinesNever
        saved.cupboardStaples = cupboardStaples
    }

    private func readKitchen(into saved: inout SavedProfile) {
        saved.equipment = equipment
        saved.experience = experience
        saved.servings = servings
        saved.units = units
        saved.weeklyGoal = weeklyGoal
        saved.focusSkill = focusSkill
        saved.onboardingDone = onboardingDone
    }

    private func writeFood(of saved: SavedProfile) {
        diet = saved.diet
        avoid = saved.avoid
        cuisinesLoved = saved.cuisinesLoved
        cuisinesToTry = saved.cuisinesToTry
        cuisinesNever = saved.cuisinesNever
        cupboardStaples = saved.cupboardStaples
    }

    private func writeKitchen(of saved: SavedProfile) {
        equipment = saved.equipment
        experience = saved.experience
        servings = saved.servings
        units = saved.units
        weeklyGoal = saved.weeklyGoal
        focusSkill = saved.focusSkill
        onboardingDone = saved.onboardingDone
    }
}
