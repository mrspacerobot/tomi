import SwiftUI
import TomiCore

/// The adapted ingredients, anything missing and equipment from the checked safe plan.
struct CookingIntroductionNeeds: View {
    let suggestion: Suggestion

    var body: some View {
        ShowCard {
            VStack(alignment: .leading, spacing: ShowSize.gap) {
                SectionHeading(words: .cookingYouWillUse)
                ingredientRows
                SuggestionMissingLine(suggestion: suggestion, style: .showText)
                equipmentSection
            }
        }
    }

    private var ingredientRows: some View {
        ForEach(Array(suggestion.recipe.ingredients.enumerated()), id: \.offset) { _, ingredient in
            RecipeIngredientRow(line: ingredient)
        }
    }

    @ViewBuilder private var equipmentSection: some View {
        if !suggestion.safePlan.equipment.isEmpty {
            VStack(alignment: .leading, spacing: Spacing.small) {
                SectionHeading(words: .cookingGetOut)
                ForEach(Array(suggestion.safePlan.equipment.enumerated()), id: \.offset) { _, item in
                    Text(verbatim: item.name).textStyle(.showText)
                }
            }
        }
    }
}
