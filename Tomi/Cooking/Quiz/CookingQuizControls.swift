import SwiftUI

/// The way on: check the ticked choice, or once right the next question; and, when the pick could not be checked,
/// carrying on without the quiz.
struct CookingQuizControls: View {
    let model: CookingQuizModel
    @Binding var path: [HomeRoute]

    var body: some View {
        VStack(spacing: Spacing.small) {
            if model.round.isAnsweredRight {
                CookingQuizNextButton(model: model)
            } else if model.problem != .graphChanged {
                CookingQuizCheckButton(model: model)
            }
            if model.problem != nil {
                CookingReturnButton(path: $path, words: .cookingQuizSkip, identifier: "cooking-quiz-skip")
            }
        }
    }
}

#Preview {
    @Previewable @State var path: [HomeRoute] = []
    if let round = PreviewSuggestion.make()?.quiz(entryID: UUID()) {
        CookingQuizControls(model: CookingQuizModel(round: round, api: CookingQuizPreviewAPI.unanswered), path: $path)
            .padding()
    }
}
