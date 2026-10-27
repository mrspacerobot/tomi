import SwiftUI
import TomiCore

/// One choice of the question. VoiceOver reads its words, "Not right" once the server said so, and "selected" when
/// it is ticked.
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
        .disabled(isRuledOut || model.round.isAnsweredRight)
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
