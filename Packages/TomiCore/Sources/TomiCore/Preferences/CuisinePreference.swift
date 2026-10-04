/// How the cook feels about one cuisine.
/// The raw values are saved, so never rename or reuse one.
public enum CuisinePreference: String, CaseIterable, Hashable, Codable, Sendable {
    /// Offer it more often.
    case love
    /// Offer it now and then. Every cuisine without an answer counts as this.
    /// The backticks are needed only here, because `try` is also a Swift keyword. Elsewhere it is plain `.try`.
    case `try`
    /// Never offer it.
    case never
}
