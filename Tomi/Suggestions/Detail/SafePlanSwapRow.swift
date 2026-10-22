import SwiftUI
import TomiCore

/// One swap: the ingredient put in for the one taken out, how much of it, and what it changes.
struct SafePlanSwapRow: View {
    let swap: SuggestionSwap

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.xxSmall) {
            Text(.suggestionSwap(swap.added.name, swap.removed.name))
                .textStyle(.body)
                .accessibilityIdentifier("suggestion-swap")
            SwapNotes(swap: swap)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
