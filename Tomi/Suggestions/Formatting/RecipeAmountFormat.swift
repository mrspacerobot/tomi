import Foundation
import TomiCore

/// Amounts of the recipe written with Foundation's formatters, never by hand.
/// An amount in a unit this build does not know is not shown, rather than shown wrong.
nonisolated enum RecipeAmountFormat {
    static func text(for amount: RecipeAmount) -> String? {
        if let measured = amount.measured {
            return AmountFormat.text(for: measured)
        }
        if let large = amount.large {
            return large.formatted(.measurement(width: .abbreviated, usage: .asProvided))
        }
        return counted(amount)
    }

    private static func counted(_ amount: RecipeAmount) -> String? {
        for unit in RecipeAmount.CountUnit.allCases {
            if let count = amount.whole(unit) {
                return words(count, of: unit)
            }
        }
        return nil
    }

    private static func words(_ count: Int, of unit: RecipeAmount.CountUnit) -> String {
        switch unit {
        case .clove: String(localized: .suggestionAmountClove(count))
        case .serving: String(localized: .suggestionAmountServing(count))
        case .pinch: String(localized: .suggestionAmountPinch(count))
        case .sprig: String(localized: .suggestionAmountSprig(count))
        case .slice: String(localized: .suggestionAmountSlice(count))
        case .leaf: String(localized: .suggestionAmountLeaf(count))
        }
    }
}
