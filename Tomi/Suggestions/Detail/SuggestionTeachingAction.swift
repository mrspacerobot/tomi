import SwiftUI
import TomiCore

/// Opens introduction only when teaching exactly matches the checked adapted recipe.
struct SuggestionTeachingAction: View {
    let suggestion: Suggestion
    @Binding var path: [HomeRoute]

    var body: some View {
        if suggestion.canOfferTeaching {
            Button {
                path.append(.introduction(suggestion))
            } label: {
                Text(.cookingIntroductionOpen).frame(maxWidth: .infinity)
            }
            .buttonStyle(.tomiPrimary)
            .accessibilityIdentifier("cooking-introduction-open")
        }
    }
}
