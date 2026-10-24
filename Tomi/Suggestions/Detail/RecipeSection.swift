import SwiftUI
import TomiCore

/// The recipe written for this cook: how much it makes, the ingredients and the numbered steps.
struct RecipeSection: View {
    let recipe: AdaptedRecipe

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.small) {
            SectionHeading(words: .suggestionRecipeTitle)
            RecipeYieldLine(yields: recipe.yields)
            ForEach(Array(recipe.ingredients.enumerated()), id: \.offset) { _, line in
                RecipeIngredientRow(line: line)
            }
            ForEach(recipe.steps, id: \.number) { step in
                RecipeStepRow(step: step)
            }
        }
    }
}
