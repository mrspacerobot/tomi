extension CuisinePreferences {
    /// The cuisines the cook gave this answer for. A cuisine without an answer is in none of the three lists.
    func cuisines(answered preference: CuisinePreference) -> Set<CuisineID> {
        var cuisines: Set<CuisineID> = []
        for (cuisine, answer) in answers where answer == preference {
            cuisines.insert(cuisine)
        }
        return cuisines
    }
}
