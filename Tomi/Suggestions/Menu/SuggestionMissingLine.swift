import SwiftUI
import TomiCore

/// What the cook still has to buy for the dish, when there is anything.
struct SuggestionMissingLine: View {
    let suggestion: Suggestion
    let style: TextStyle

    var body: some View {
        if !suggestion.safePlan.missing.isEmpty {
            Text(.suggestionMissing(suggestion.safePlan.missing.map(\.name).formatted(.list(type: .and))))
                .textStyle(style)
                .accessibilityIdentifier("suggestion-missing")
        }
    }
}
