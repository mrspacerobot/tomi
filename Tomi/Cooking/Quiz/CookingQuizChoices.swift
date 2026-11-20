import SwiftUI
import TomiCore

/// The choices of the question as tick rows under a cobalt rule (`.q-opts`). A choice the server said is wrong is
/// crossed out and says so; once the question is answered right, nothing more can be ticked.
struct CookingQuizChoices: View {
    let model: CookingQuizModel

    var body: some View {
        VStack(spacing: ShowSize.gap) {
            ForEach(Array(model.round.current.choices.enumerated()), id: \.offset) { position, choice in
                CookingQuizChoice(model: model, position: position, words: choice)
            }
        }

    }
}

#Preview {
    if let round = PreviewSuggestion.make()?.quiz(entryID: UUID()) {
        CookingQuizChoices(model: CookingQuizModel(round: round, api: CookingQuizPreviewAPI.unanswered))
            .background { ShowStage() }
    }
}
