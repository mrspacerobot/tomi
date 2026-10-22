import SwiftUI
import TomiCore

/// One dish on suggestion: its name, technique and level, the server's reason, what changed in the recipe and what
/// was checked. The button opens the recipe.
struct SuggestionCard: View {
    let suggestion: Suggestion
    let options: LibraryOptions
    /// The label set into the box of tonight's special, nil for an alternative.
    let flag: LocalizedStringResource?
    let open: () -> Void

    var body: some View {
        DoubleRuledBox(flag: flag) {
            VStack(alignment: .leading, spacing: Spacing.small) {
                SuggestionHeading(suggestion: suggestion, isSpecial: flag != nil)
                SuggestionSummary(suggestion: suggestion, options: options)
                Button(action: open) { Text(.suggestionOpen) }
                    .buttonStyle(.tomiPrimary)
                    .accessibilityIdentifier("suggestion-open-" + suggestion.recipeID.rawValue)
            }
        }
    }
}
