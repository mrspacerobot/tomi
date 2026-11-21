import SwiftUI
import TomiCore

/// One swap: the food put in for the one taken out, and what that changes about the dish, when the server says.
struct ChangeSwapRow: View {
    let swap: SuggestionSwap

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.xxSmall) {
            Text(.suggestionSwap(swap.added.name, swap.removed.name))
                .textStyle(.showText)
                .accessibilityIdentifier("suggestion-swap")
            if let caveat = swap.caveat {
                Text(verbatim: caveat)
                    .textStyle(.showNote)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
