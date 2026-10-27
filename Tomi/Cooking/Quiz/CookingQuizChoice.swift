import SwiftUI
import TomiCore

/// One choice of the question. VoiceOver reads its words, "Not right" once the server said so, and "selected" when
/// it is ticked. A crossed-out choice, or any choice once the question is right, ignores a tap (`QuizRound.tick`)
/// rather than being disabled, so it keeps its full colour, as in the mockup.
struct CookingQuizChoice: View {
    let model: CookingQuizModel
    let position: Int
    let words: String

    var body: some View {
        TickRow(
            name: words,
            note: note,
            isSelected: model.round.ticked == position,
            isCrossedOut: isRuledOut
        ) {
            model.tick(position)
        }
        .accessibilityIdentifier("cooking-quiz-choice-" + String(position))
    }

    private var isRuledOut: Bool {
        model.round.ruledOut.contains(position)
    }

    private var note: String? {
        guard isRuledOut else { return nil }
        return String(localized: .cookingQuizNotRight)
    }
}

#Preview {
    if let round = PreviewSuggestion.make()?.quiz(entryID: UUID()) {
        let model = CookingQuizModel(round: round, api: CookingQuizPreviewAPI.unanswered)
        CookingQuizChoice(model: model, position: 0, words: round.current.choices[0])
            .background(ColorRole.paper.color)
    }
}
