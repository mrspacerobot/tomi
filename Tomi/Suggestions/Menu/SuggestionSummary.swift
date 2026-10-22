import SwiftUI
import TomiCore

/// What the safe plan changes for this cook, what to buy, and what the server checked the dish against.
/// This is the menu's short form of the plan; the detail screen has all of it.
struct SuggestionSummary: View {
    let suggestion: Suggestion
    let options: LibraryOptions

    var body: some View {
        ForEach(suggestion.safePlan.substitutions, id: \.id) { swap in
            Text(.suggestionSwap(swap.added.name, swap.removed.name))
                .textStyle(.description)
        }
        SuggestionOmittedLine(suggestion: suggestion, style: .description)
        SuggestionMissingLine(suggestion: suggestion, style: .description)
        SuggestionCheckedLine(checked: suggestion.checked, options: options)
    }
}
