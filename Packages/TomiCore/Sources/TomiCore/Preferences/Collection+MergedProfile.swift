/// One profile out of every profile record in the store. There should be one record, but nothing stops two devices
/// from each saving their own before iCloud brings them together.
extension Collection where Element == SavedProfile {
    /// The cook's profile, or nil when nothing is saved yet. The answer never depends on the order of the records.
    /// The record changed last gives every answer except what the cook may eat, which takes the strictest reading
    /// of all records: Tomi cannot know which device the cook meant, so no restriction is dropped
    /// until the cook answers again and the records become one.
    public var mergedProfile: CookProfile? {
        guard !isEmpty else {
            return nil
        }
        var profile = CookProfile()
        if let newest {
            profile = newest.profile
        }
        profile.preferences.avoid = everyAvoidItem
        profile.preferences.diet = strictestDiet
        return profile
    }

    private var everyAvoidItem: Set<AvoidItemID> {
        var avoid: Set<AvoidItemID> = []
        for record in self {
            avoid.formUnion(record.preferences.avoid)
        }
        return avoid
    }

    /// The one diet the records name. Two different diets cannot both be kept, so they become the unreadable diet,
    /// which refuses every dish until the cook answers again.
    private var strictestDiet: DietID? {
        var diets: Set<DietID> = []
        for record in self {
            if let diet = record.preferences.diet {
                diets.insert(diet)
            }
        }
        if diets.count > 1 {
            return DietID.unreadable
        }
        return diets.first
    }
}
