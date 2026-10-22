import SwiftUI
import TomiCore

/// The graph's own recipe, word for word. It is never described as adapted: the plan above is what changes.
struct OriginalRecipeSection: View {
    let suggestion: Suggestion

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.small) {
            OriginalRecipeHeader(recipe: suggestion.originalRecipe)
            ForEach(Array(suggestion.originalRecipe.ingredients.enumerated()), id: \.offset) { _, line in
                RecipeIngredientRow(suggestion: suggestion, line: line)
            }
            ForEach(Array(suggestion.originalRecipe.steps.enumerated()), id: \.offset) { position, step in
                RecipeStepRow(number: position + 1, step: step)
            }
        }
        .accessibilityIdentifier("suggestion-original")
    }
}
