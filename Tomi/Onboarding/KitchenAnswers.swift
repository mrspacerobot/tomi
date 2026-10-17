import SwiftUI
import TomiCore

/// What the kitchen has. Until the cook taps, the rows show what the server assumes a kitchen has.
struct KitchenAnswers: View {
    let draft: AnswersDraft

    var body: some View {
        ChoiceList(choices: choices, isSelected: isSelected) { choice in
            if let id = choice.optionID {
                draft.answers.toggleEquipment(id, assumedUntilAnswered: draft.options.assumedEquipment)
            }
        }
    }

    private var choices: [TickChoice] {
        draft.options.equipment.map { TickChoice(optionID: $0.id, name: $0.name, note: $0.summary) }
    }

    private func isSelected(_ choice: TickChoice) -> Bool {
        guard let id = choice.optionID else {
            return false
        }
        return draft.answers.kitchen(assumedUntilAnswered: draft.options.assumedEquipment).contains(id)
    }
}

#Preview {
    KitchenAnswers(draft: .preview())
        .background(ColorRole.paper.color)
}
