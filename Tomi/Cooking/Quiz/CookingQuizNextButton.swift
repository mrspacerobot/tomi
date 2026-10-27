import SwiftUI

/// On to the next question once this one is right, or to the end of the quiz after the last.
struct CookingQuizNextButton: View {
    let model: CookingQuizModel

    var body: some View {
        Button {
            model.advance()
        } label: {
            Text(label).frame(maxWidth: .infinity)
        }
        .buttonStyle(.tomiPrimary)
        .accessibilityIdentifier("cooking-quiz-next")
    }

    private var label: LocalizedStringResource {
        if model.round.isLast {
            return .cookingQuizFinish
        }
        return .cookingQuizNext
    }
}

#Preview {
    if let round = PreviewSuggestion.make()?.quiz(entryID: UUID()) {
        CookingQuizNextButton(model: CookingQuizModel(round: round, api: CookingQuizPreviewAPI.unanswered)).padding()
    }
}
