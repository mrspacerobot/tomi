/// Saved as a plain object of cuisine id to answer, such as `{"italian": "love"}`.
extension CuisinePreferences {
    /// An answer this build does not know, written by a newer app, is left out, so that cuisine counts as "try".
    public init(from decoder: any Decoder) throws {
        let savedAnswers = try decoder.singleValueContainer().decode([String: String].self)
        for (savedCuisine, savedPreference) in savedAnswers {
            if let preference = CuisinePreference(rawValue: savedPreference) {
                set(preference, for: CuisineID(rawValue: savedCuisine))
            }
        }
    }

    public func encode(to encoder: any Encoder) throws {
        var savedAnswers: [String: String] = [:]
        for (cuisine, preference) in answers {
            savedAnswers[cuisine.rawValue] = preference.rawValue
        }
        var container = encoder.singleValueContainer()
        try container.encode(savedAnswers)
    }
}
