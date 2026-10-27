import SwiftUI
import TomiCore

/// One question: where the cook is in the quiz, the question and its choices, what the server said, and the way on.
/// The choices run from edge to edge, so everything else keeps the screen margin itself.
struct CookingQuizPage: View {
    let model: CookingQuizModel
    @Binding var path: [HomeRoute]

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.xLarge) {
            CookingQuizQuestion(round: model.round)
                .padding(.horizontal, Spacing.screenMargin)
            CookingQuizChoices(model: model)
            Group {
                CookingQuizOutcomeNote(model: model)
                CookingQuizControls(model: model, path: $path)
            }
            .padding(.horizontal, Spacing.screenMargin)
        }
        .padding(.vertical, Spacing.screenMargin)
    }
}

#Preview {
    CookingQuizPreview()
}
