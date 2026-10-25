import SwiftUI
import TomiCore

/// A dish on suggestion in full: the recipe already adapted for this cook, what changed for them, what they still
/// have to buy and what it was checked against. Cooking a graph recipe step by step is not built yet (#135).
struct SuggestionDetailView: View {
    let suggestion: Suggestion
    let options: LibraryOptions
    @Binding var path: [HomeRoute]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.xLarge) {
                VStack(alignment: .leading, spacing: Spacing.small) {
                    SuggestionHeading(suggestion: suggestion, isSpecial: true)
                }
                RecipeSection(recipe: suggestion.recipe)
                ChangesSection(changes: suggestion.changes)
                NeedsSection(suggestion: suggestion, options: options)
                SuggestionTeachingAction(suggestion: suggestion, path: $path)
            }
            .padding(Spacing.screenMargin)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(ColorRole.paper.color)
        .accessibilityIdentifier("suggestion-detail")
    }
}
