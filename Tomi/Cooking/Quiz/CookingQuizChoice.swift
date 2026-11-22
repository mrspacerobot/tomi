import SwiftUI
import TomiCore

/// The picked state and verdict are both carried as words and accessibility traits.
struct CookingQuizChoice: View {
    let model: CookingQuizModel
    let position: Int
    let words: String

    var body: some View {
        Button {
            model.tick(position)
        } label: {
            ShowCard {
                CookingQuizChoiceLabel(words: words, position: position, ruledOut: isRuledOut)
            }
            .overlay {
                RoundedRectangle(cornerRadius: Radius.showCard).strokeBorder(ring, lineWidth: RuleWeight.showRing)
            }
        }
        .buttonStyle(.plain)
        .accessibilitySelected(isSelected)
        .accessibilityIdentifier("cooking-quiz-choice-" + String(position))
    }

    private var isSelected: Bool { model.round.ticked == position }
    private var isRuledOut: Bool { model.round.ruledOut.contains(position) }

    private var ring: Color {
        if isRuledOut { return ColorRole.showNotQuite.color }
        guard isSelected else { return .clear }
        if model.round.isAnsweredRight { return ColorRole.showCorrect.color }
        return ColorRole.showAccent.color
    }
}

#Preview {
    if let round = PreviewSuggestion.make()?.quiz(entryID: UUID()) {
        let model = CookingQuizModel(round: round, api: CookingQuizPreviewAPI.unanswered)
        CookingQuizChoice(model: model, position: 0, words: round.current.choices[0]).background { ShowStage() }
    }
}
