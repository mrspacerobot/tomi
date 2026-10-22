import SwiftUI
import TomiCore

/// How much the graph's recipe makes, so its amounts can be read: whole servings, or another amount.
struct OriginalYieldLine: View {
    let yields: RecipeAmount

    var body: some View {
        if let servings = yields.wholeServings {
            Text(.suggestionOriginalYieldServings(servings))
                .textStyle(.body)
                .accessibilityIdentifier("suggestion-original-yield")
        } else if let amount = RecipeAmountFormat.text(for: yields) {
            Text(.suggestionOriginalYieldAmount(amount))
                .textStyle(.body)
                .accessibilityIdentifier("suggestion-original-yield")
        }
    }
}
