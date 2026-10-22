/// The one food check left on the phone: a guard against showing a dish the server did not check for this cook.
/// It decides nothing about food. It only refuses a suggestion whose stated check does not cover the cook's answers.
extension Suggestion {
    /// Whether the server checked this suggestion for the cook's diet and for everything they avoid.
    /// The diet must be the same, a cook who eats everything included, and the checked avoid list must hold
    /// every item the cook avoids. Anything else hides the suggestion.
    public func isChecked(for profile: CookProfile) -> Bool {
        guard checked.diet == profile.diet else {
            return false
        }
        return profile.avoid.isSubset(of: checked.avoid)
    }
}
