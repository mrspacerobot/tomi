/// How much the cook already cooks, as answered in onboarding.
/// The raw values are saved, so never rename or reuse one.
public enum Experience: String, CaseIterable, Hashable, Codable, Sendable {
    /// Starts at the first dish, with everything explained.
    case never
    /// Starts at the first course, with shorter explanations.
    case basics
    /// The server counts the first course as already mastered.
    case comfortable
}
