import SwiftUI
import TomiCore

/// The swaps and the left-out parts, or a plain line saying nothing had to change.
struct ChangeRows: View {
    let changes: RecipeChanges

    var body: some View {
        if changes.swaps.isEmpty && changes.leftOut.isEmpty {
            Text(.suggestionChangesNone)
                .textStyle(.body)
                .accessibilityIdentifier("suggestion-changes-none")
        }
        ForEach(changes.swaps, id: \.id) { swap in
            ChangeSwapRow(swap: swap)
        }
        ForEach(changes.leftOut) { part in
            Text(.suggestionOmitted(part.name))
                .textStyle(.body)
                .accessibilityIdentifier("suggestion-left-out")
        }
    }
}
