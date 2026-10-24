import SwiftUI
import TomiCore

/// What changed in the recipe for this cook, what to buy, and what the server checked the dish against.
/// This is the menu's short form; the detail screen has the whole recipe.
struct SuggestionSummary: View {
    let suggestion: Suggestion
    let options: LibraryOptions

    var body: some View {
        ForEach(suggestion.changes.swaps, id: \.id) { swap in
            Text(.suggestionSwap(swap.added.name, swap.removed.name))
                .textStyle(.description)
        }
        SuggestionOmittedLine(leftOut: suggestion.changes.leftOut, style: .description)
        SuggestionMissingLine(suggestion: suggestion, style: .description)
        SuggestionCheckedLine(checked: suggestion.checked, options: options)
    }
}
