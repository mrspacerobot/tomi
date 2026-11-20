import SwiftUI
import TomiCore

/// The dish's name, its technique and level, and the server's reason for it, all in the server's words.
struct SuggestionHeading: View {
    let suggestion: Suggestion
    let isSpecial: Bool

    var body: some View {
        Text(verbatim: suggestion.title)
            .textStyle(titleStyle)
            .accessibilityIdentifier("suggestion-title-" + suggestion.recipeID.rawValue)
        Text(.suggestionLine(suggestion.skill.name, suggestion.level.name))
            .textStyle(.showMeta)
        if let reason = suggestion.reason {
            Text(verbatim: reason)
                .textStyle(.showText)
        }
    }

    private var titleStyle: TextStyle {
        if isSpecial {
            return .cardTitle
        }
        return .showBodyStrong
    }
}
