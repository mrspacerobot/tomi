import Foundation
import TomiCore

/// Amounts written with Foundation's formatters, never by hand.
nonisolated enum AmountFormat {
    static func text(for amount: Amount) -> String {
        let style = Measurement<Dimension>.FormatStyle(width: .abbreviated, usage: .asProvided)
        guard let unit = dimension(of: amount.unit) else {
            return amount.value.formatted()
        }
        return Measurement(value: amount.value, unit: unit).formatted(style)
    }

    /// The unit as Foundation knows it, or nil for a count of whole things.
    private static func dimension(of unit: AmountUnit) -> Dimension? {
        switch unit {
        case .gram: UnitMass.grams
        case .millilitre: UnitVolume.milliliters
        case .cup: UnitVolume.cups
        case .tablespoon: UnitVolume.tablespoons
        case .teaspoon: UnitVolume.teaspoons
        case .piece: nil
        }
    }
}
