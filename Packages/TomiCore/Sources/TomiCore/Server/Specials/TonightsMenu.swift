/// The suggestions the cook is shown: tonight's special and at most two alternatives, all checked for this cook.
public struct TonightsMenu: Hashable, Sendable {
    public static let mostAlternatives = 2

    public let special: Suggestion?
    public let alternatives: [Suggestion]

    /// Every suggestion whose check does not cover the cook is left out (`Suggestion.isChecked(for:)`).
    /// When the special is left out, the first alternative that passes takes its place.
    public init(_ response: SpecialsResponse, for profile: CookProfile) {
        var suggestions: [Suggestion] = []
        if let special = response.special {
            suggestions.append(special)
        }
        suggestions += response.alternatives
        let checked = suggestions.filter { $0.isChecked(for: profile) }
        special = checked.first
        alternatives = Array(checked.dropFirst().prefix(Self.mostAlternatives))
    }

    /// Whether there is nothing to cook tonight.
    public var isEmpty: Bool {
        special == nil
    }
}
