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
            VStack(alignment: .leading, spacing: ShowSize.rowGap) {
                ShowMarquee(title: .suggestionsKicker)
                ShowCard { SuggestionHeading(suggestion: suggestion, isSpecial: true) }
                ShowCard { RecipeSection(recipe: suggestion.recipe) }
                ShowCard { ChangesSection(changes: suggestion.changes) }
                ShowCard { NeedsSection(suggestion: suggestion, options: options) }
                SuggestionTeachingAction(suggestion: suggestion, path: $path)
            }
            .padding(ShowSize.edge)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background { ShowStage() }
        .accessibilityIdentifier("suggestion-detail")
    }
}
