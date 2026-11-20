import SwiftUI
import TomiCore

/// The suggestion kicker, dish title and server supplied technique, step count and yield.
struct CookingIntroductionHeader: View {
    let suggestion: Suggestion

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.small) {
            ShowLowerThird(title: .showtimeBeforeRoll)
            Text(suggestion.title).textStyle(.showTitle)
            if let teaching = suggestion.teaching,
                let yieldText = RecipeYieldLine.words(for: suggestion.recipe.yields)
            {
                Text(.cookingIntroductionMeta(teaching.technique.name, suggestion.recipe.steps.count, yieldText))
                    .textStyle(.showLede, color: .stageMuted)
            }
        }
    }
}
