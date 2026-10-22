import SwiftUI
import TomiCore

/// The parts of the dish the safe plan leaves out, when it leaves any out.
struct SuggestionOmittedLine: View {
    let suggestion: Suggestion
    let style: TextStyle

    var body: some View {
        if !suggestion.safePlan.omittedParts.isEmpty {
            Text(.suggestionOmitted(suggestion.omittedNames.formatted(.list(type: .and))))
                .textStyle(style)
                .accessibilityIdentifier("suggestion-omitted")
        }
    }
}
