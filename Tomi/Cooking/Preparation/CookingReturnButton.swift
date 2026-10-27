import SwiftUI

/// Leaves the cooking screens and returns to the suggestion detail they began from.
struct CookingReturnButton: View {
    @Binding var path: [HomeRoute]
    var words: LocalizedStringResource = .cookingNotTonight
    var identifier = "cooking-return-to-suggestion"

    var body: some View {
        Button(action: returnToSuggestion) {
            Text(words).frame(maxWidth: .infinity)
        }
        .buttonStyle(.tomiSecondary)
        .accessibilityIdentifier(identifier)
    }

    private func returnToSuggestion() {
        while let last = path.last, !last.isSuggestion {
            path.removeLast()
        }
    }
}
