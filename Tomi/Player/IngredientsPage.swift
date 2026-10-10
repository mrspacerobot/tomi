import SwiftUI
import TomiCore

/// The dish's name and everything to get out, in the cook's units, named as the server named them.
struct IngredientsPage: View {
    let model: PlayerModel

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.medium) {
            Text(verbatim: model.offer.title)
                .textStyle(.displayM)
                .accessibilityIdentifier("player-title")
            Text(verbatim: LessonText.resolved(model.dish.concept))
                .textStyle(.body)
            ForEach(model.dish.ingredients, id: \.ingredient) { line in
                IngredientLine(name: name(of: line.ingredient), amount: line.amount(in: model.units))
            }
        }
    }

    private func name(of ingredient: IngredientID) -> String {
        let named = model.offer.ingredients.first { $0.id.rawValue == ingredient.rawValue }
        guard let named else {
            return ingredient.rawValue
        }
        return named.name
    }
}
