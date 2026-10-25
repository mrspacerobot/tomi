import SwiftUI
import TomiCore

/// Adapted ingredient and equipment checklist with local, unpersisted checked state.
struct CookingPreparationChecklist: View {
    let suggestion: Suggestion
    @State private var checkedItems: Set<String> = []

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.small) {
            RecipeYieldLine(yields: suggestion.recipe.yields)
            ingredientChecklist
            SuggestionMissingLine(suggestion: suggestion, style: .body)
            equipmentChecklist
        }
    }

    private var ingredientChecklist: some View {
        VStack(alignment: .leading, spacing: Spacing.small) {
            SectionHeading(words: .cookingIngredients)
            ForEach(Array(suggestion.recipe.ingredients.enumerated()), id: \.offset) { _, ingredient in
                TickRow(
                    name: ingredient.food.name,
                    note: RecipeAmountFormat.text(for: ingredient.amount),
                    isSelected: checkedItems.contains(ingredient.food.id.rawValue)
                ) { toggle(ingredient.food.id.rawValue) }
                .accessibilityIdentifier("preparation-ingredient-" + ingredient.food.id.rawValue)
            }
        }
    }

    @ViewBuilder private var equipmentChecklist: some View {
        if !suggestion.safePlan.equipment.isEmpty {
            VStack(alignment: .leading, spacing: Spacing.small) {
                SectionHeading(words: .cookingEquipment)
                ForEach(Array(suggestion.safePlan.equipment.enumerated()), id: \.offset) { _, equipment in
                    TickRow(
                        name: equipment.name,
                        isSelected: checkedItems.contains(equipment.id.rawValue)
                    ) { toggle(equipment.id.rawValue) }
                    .accessibilityIdentifier("preparation-equipment-" + equipment.id.rawValue)
                }
            }
        }
    }

    private func toggle(_ identifier: String) {
        if checkedItems.contains(identifier) {
            checkedItems.remove(identifier)
        } else {
            checkedItems.insert(identifier)
        }
    }
}
