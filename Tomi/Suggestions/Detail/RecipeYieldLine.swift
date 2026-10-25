import SwiftUI
import TomiCore

/// How much the recipe makes, so its amounts can be read: whole servings, or another amount.
struct RecipeYieldLine: View {
    let yields: RecipeAmount

    var body: some View {
        if let servings = yields.wholeServings {
            Text(.suggestionRecipeYieldServings(servings))
                .textStyle(.body)
                .accessibilityIdentifier("suggestion-yield")
        } else if let amount = RecipeAmountFormat.text(for: yields) {
            Text(.suggestionRecipeYieldAmount(amount))
                .textStyle(.body)
                .accessibilityIdentifier("suggestion-yield")
        }
    }
}
