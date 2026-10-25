import SwiftUI
import TomiCore

/// The adapted recipe's preparation checklist before guided steps are available.
struct CookingPreparationView: View {
    let suggestion: Suggestion
    @Binding var path: [HomeRoute]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.xLarge) {
                Text(suggestion.title).textStyle(.displayM)
                CookingPreparationChecklist(suggestion: suggestion)
                Text(.cookingStepsUnavailable).textStyle(.body).accessibilityIdentifier("cooking-steps-unavailable")
                CookingReturnButton(path: $path)
            }
            .padding(Spacing.screenMargin)
        }
        .background(ColorRole.paper.color)
        .navigationTitle(Text(.cookingPreparationTitle))
        .navigationBarTitleDisplayMode(.inline)
    }
}
