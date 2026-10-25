import SwiftUI

/// Leaves preparation and returns to its suggestion detail.
struct CookingReturnButton: View {
    @Binding var path: [HomeRoute]

    var body: some View {
        Button(action: returnToSuggestion) {
            Text(.cookingNotTonight).frame(maxWidth: .infinity)
        }
        .buttonStyle(.tomiSecondary)
        .accessibilityIdentifier("cooking-return-to-suggestion")
    }

    private func returnToSuggestion() {
        if path.count >= 2 { path.removeLast(2) } else { path.removeLast() }
    }
}
