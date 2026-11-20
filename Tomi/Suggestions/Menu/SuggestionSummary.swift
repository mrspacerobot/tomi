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
                .textStyle(.showNote)
        }
        SuggestionOmittedLine(leftOut: suggestion.changes.leftOut, style: .showNote)
        SuggestionMissingLine(suggestion: suggestion, style: .showNote)
        SuggestionCheckedLine(checked: suggestion.checked, options: options)
    }
}
