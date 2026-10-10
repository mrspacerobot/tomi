import SwiftUI
import TomiCore

/// Everything the cook does not eat, as many as they like.
struct AvoidAnswers: View {
    let draft: AnswersDraft

    var body: some View {
        ChoiceList(choices: choices, isSelected: isSelected) { choice in
            if let id = choice.optionID {
                draft.answers.toggleAvoid(id)
            }
        }
    }

    private var choices: [TickChoice] {
        draft.options.avoidItems.map { TickChoice(optionID: $0.id, name: $0.name) }
    }

    private func isSelected(_ choice: TickChoice) -> Bool {
        guard let id = choice.optionID else {
            return false
        }
        return draft.answers.avoid.contains(id)
    }
}

#Preview {
    AvoidAnswers(draft: .preview())
        .background(ColorRole.paper.color)
}
