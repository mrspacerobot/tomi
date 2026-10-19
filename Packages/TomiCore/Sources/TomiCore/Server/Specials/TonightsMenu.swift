/// The offers the cook is shown: tonight's special and at most two alternatives, all checked for this cook.
public struct TonightsMenu: Hashable, Sendable {
    public static let mostAlternatives = 2

    public let special: Offer?
    public let alternatives: [Offer]

    /// Every offer whose check does not cover the cook is left out (`Offer.isChecked(for:)`).
    /// When the special is left out, the first alternative that passes takes its place.
    public init(_ response: SpecialsResponse, for profile: CookProfile) {
        var offers: [Offer] = []
        if let special = response.special {
            offers.append(special)
        }
        offers += response.alternatives
        let checked = offers.filter { $0.isChecked(for: profile) }
        special = checked.first
        alternatives = Array(checked.dropFirst().prefix(Self.mostAlternatives))
    }

    /// Whether there is nothing to cook tonight.
    public var isEmpty: Bool {
        special == nil
    }
}
