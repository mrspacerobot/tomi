import SwiftUI

/// Sends the ticked choice to the server. It cannot be pressed before a choice is ticked or while a pick is on its
/// way; after a pick could not be checked it tries the same pick again.
struct CookingQuizCheckButton: View {
    let model: CookingQuizModel

    var body: some View {
        Button {
            Task { await model.check() }
        } label: {
            Text(label).frame(maxWidth: .infinity)
        }
        .buttonStyle(ShowPrimaryButtonStyle())
        .disabled(!model.canCheck)
        .accessibilityIdentifier("cooking-quiz-check")
    }

    private var label: LocalizedStringResource {
        if model.isChecking {
            return .cookingQuizChecking
        }
        if model.problem != nil {
            return .cookingQuizTryAgain
        }
        return .cookingQuizCheck
    }
}

#Preview {
    if let round = PreviewSuggestion.make()?.quiz(entryID: UUID()) {
        CookingQuizCheckButton(model: CookingQuizModel(round: round, api: CookingQuizPreviewAPI.unanswered)).padding()
    }
}
