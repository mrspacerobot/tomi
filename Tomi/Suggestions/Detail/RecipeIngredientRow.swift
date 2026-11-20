import SwiftUI
import TomiCore

/// One ingredient line of the recipe: the food to use, how much, and the forms it is prepared in.
struct RecipeIngredientRow: View {
    let line: AdaptedIngredient

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.xxSmall) {
            AmountRow(
                name: line.food.name,
                amount: RecipeAmountFormat.text(for: line.amount)
            )
            if !line.forms.isEmpty {
                Text(verbatim: line.forms.map(\.name).formatted(.list(type: .and)))
                    .textStyle(.showNote)
            }
        }
    }
}
