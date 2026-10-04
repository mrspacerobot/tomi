/// What an amount in a lesson is counted in. A closed list, so code can scale an amount and format it
/// for the cook's language instead of showing text someone typed.
/// The raw values are written in the library, so never rename or reuse one.
public enum AmountUnit: String, CaseIterable, Hashable, Codable, Sendable {
    case gram
    case millilitre
    case cup
    case tablespoon
    case teaspoon
    /// A count of whole things: two cloves, four thighs, half a lemon.
    case piece

    /// Whether a recipe card in these units may use this unit. Counts and spoons are at home in both.
    public func belongs(to units: Units) -> Bool {
        switch self {
        case .gram, .millilitre: units == .metric
        case .cup: units == .cups
        case .tablespoon, .teaspoon, .piece: true
        }
    }
}
