import SwiftUI
import TomiCore

/// The adapted recipe's preparation checklist before guided steps are available.
struct CookingPreparationView: View {
    let suggestion: Suggestion
    @Binding var path: [HomeRoute]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.xLarge) {
                Text(suggestion.title).textStyle(.displayM)
                CookingPreparationChecklist(suggestion: suggestion)
                Text(.cookingStepsUnavailable).textStyle(.body).accessibilityIdentifier("cooking-steps-unavailable")
                CookingReturnButton(path: $path)
            }
            .padding(Spacing.screenMargin)
        }
        .background(ColorRole.paper.color)
        .navigationTitle(Text(.cookingPreparationTitle))
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct CookingPreparationChecklist: View {
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

private struct CookingReturnButton: View {
    @Binding var path: [HomeRoute]

    var body: some View {
        Button(action: returnToSuggestion) {
            Text(.cookingNotTonight).frame(maxWidth: .infinity)
        }
        .buttonStyle(.tomiSecondary)
        .accessibilityIdentifier("cooking-return-to-suggestion")
    }

    private func returnToSuggestion() {
        if path.count >= 2 { path.removeLast(2) } else { path.removeLast() }
    }
}
