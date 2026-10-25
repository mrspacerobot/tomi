import SwiftUI
import TomiCore

/// How much the recipe makes, so its amounts can be read: whole servings, or another amount.
struct RecipeYieldLine: View {
    let yields: RecipeAmount

    var body: some View {
        if let words = Self.words(for: yields) {
            Text(verbatim: words)
                .textStyle(.body)
                .accessibilityIdentifier("suggestion-yield")
        }
    }

    static func words(for yields: RecipeAmount) -> String? {
        if let servings = yields.wholeServings {
            return String(localized: .suggestionRecipeYieldServings(servings))
        }
        guard let amount = RecipeAmountFormat.text(for: yields) else { return nil }
        return String(localized: .suggestionRecipeYieldAmount(amount))
    }
}
