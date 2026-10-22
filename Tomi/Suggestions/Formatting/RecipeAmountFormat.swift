import Foundation
import TomiCore

/// Amounts of the graph's recipe written with Foundation's formatters, never by hand.
/// An amount in a unit this build does not know is not shown, rather than shown wrong.
nonisolated enum RecipeAmountFormat {
    static func text(for amount: RecipeAmount) -> String? {
        if let measured = amount.measured {
            return AmountFormat.text(for: measured)
        }
        if let cloves = amount.wholeCloves {
            return String(localized: .suggestionAmountClove(cloves))
        }
        return nil
    }
}
