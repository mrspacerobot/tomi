import SwiftUI
import TomiCore

/// Adapted ingredient and equipment checklist with local, unpersisted checked state.
struct CookingPreparationChecklist: View {
    let suggestion: Suggestion
    @State private var checkedItems: Set<String> = []

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.small) {
            ShowCard { RecipeYieldLine(yields: suggestion.recipe.yields) }
            ingredientChecklist
            SuggestionMissingLine(suggestion: suggestion, style: .showLede)
            equipmentChecklist
        }
    }

    private var ingredientChecklist: some View {
        VStack(alignment: .leading, spacing: Spacing.small) {
            ShowLowerThird(title: .cookingIngredients)
            ForEach(Array(suggestion.recipe.ingredients.enumerated()), id: \.offset) { _, ingredient in
                PreparationCheckRow(
                    choice: choice(for: ingredient),
                    selected: checkedItems.contains(ingredient.food.id.rawValue),
                    toggle: { toggle(ingredient.food.id.rawValue) }
                )
                .accessibilityIdentifier("preparation-ingredient-" + ingredient.food.id.rawValue)
            }
        }
    }

    @ViewBuilder private var equipmentChecklist: some View {
        if !suggestion.safePlan.equipment.isEmpty {
            VStack(alignment: .leading, spacing: Spacing.small) {
                ShowLowerThird(title: .cookingEquipment)
                ForEach(Array(suggestion.safePlan.equipment.enumerated()), id: \.offset) { _, equipment in
                    PreparationCheckRow(
                        choice: TickChoice(optionID: nil, name: equipment.name),
                        selected: checkedItems.contains(equipment.id.rawValue),
                        toggle: { toggle(equipment.id.rawValue) }
                    )
                    .accessibilityIdentifier("preparation-equipment-" + equipment.id.rawValue)
                }
            }
        }
    }

    private func choice(for ingredient: AdaptedIngredient) -> TickChoice {
        TickChoice(
            optionID: nil,
            name: ingredient.food.name,
            note: RecipeAmountFormat.text(for: ingredient.amount)
        )
    }

    private func toggle(_ identifier: String) {
        if checkedItems.contains(identifier) {
            checkedItems.remove(identifier)
        } else {
            checkedItems.insert(identifier)
        }
    }
}
