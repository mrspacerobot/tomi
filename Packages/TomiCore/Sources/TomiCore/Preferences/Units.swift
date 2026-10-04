import Foundation

/// How amounts and temperatures are written on a recipe card.
/// The raw values are saved, so never rename or reuse one.
public enum Units: String, CaseIterable, Hashable, Codable, Sendable {
    /// Grams, millilitres and degrees Celsius.
    case metric
    /// Cups, ounces and degrees Fahrenheit.
    case cups

    /// What a cook in this locale expects before they have chosen. Only the United States system means cups:
    /// the United Kingdom measures roads in miles but recipes in grams.
    public static func standard(for locale: Locale) -> Units {
        if locale.measurementSystem == .us {
            return .cups
        }
        return .metric
    }
}
