import SwiftUI
import TomiCore

/// The other dishes the cook could make tonight, under their heading.
struct AlternativesList: View {
    let suggestions: [Suggestion]
    let options: LibraryOptions
    @Binding var path: [HomeRoute]

    var body: some View {
        if !suggestions.isEmpty {
            Text(.suggestionsAlternatives)
                .textStyle(.showLabel)
                .textCase(.uppercase)
            ForEach(suggestions) { suggestion in
                SuggestionCard(suggestion: suggestion, options: options, flag: nil) {
                    path.append(.suggestion(suggestion))
                }
            }
        }
    }
}
