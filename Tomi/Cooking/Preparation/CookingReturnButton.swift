import SwiftUI

/// Leaves the cooking screens and returns to the suggestion detail they began from.
struct CookingReturnButton: View {
    @Binding var path: [HomeRoute]
    var words: LocalizedStringResource = .cookingNotTonight
    var identifier = "cooking-return-to-suggestion"
    var beforeLeaving: () -> Void = {}

    var body: some View {
        Button(action: returnToSuggestion) {
            Text(words).frame(maxWidth: .infinity)
        }
        .buttonStyle(ShowSecondaryButtonStyle())
        .accessibilityIdentifier(identifier)
    }

    private func returnToSuggestion() {
        beforeLeaving()
        path.returnToSuggestion()
    }
}
