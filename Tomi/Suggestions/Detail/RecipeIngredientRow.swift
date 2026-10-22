import SwiftUI
import TomiCore

/// One ingredient line of the graph's recipe, with a plain note when the plan swaps it or leaves it out.
struct RecipeIngredientRow: View {
    let suggestion: Suggestion
    let line: RecipeIngredient

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.xxSmall) {
            AmountRow(name: suggestion.name(ofSourceIngredient: line.thing), amount: amount)
            if let swap = suggestion.substitution(for: line) {
                Text(.suggestionOriginalSwapped(swap.added.name))
                    .textStyle(.caption)
            }
            if suggestion.omits(line) {
                Text(.suggestionOriginalOmitted)
                    .textStyle(.caption)
            }
        }
    }

    private var amount: String? {
        guard let amount = line.amount else {
            return nil
        }
        return RecipeAmountFormat.text(for: amount)
    }
}
