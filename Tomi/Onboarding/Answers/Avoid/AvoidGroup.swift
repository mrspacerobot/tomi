import SwiftUI
import TomiCore

/// One group of the avoid question: a small heading and its tick rows. A group with no rows shows nothing.
struct AvoidGroup: View {
    let title: LocalizedStringResource?
    let choices: [TickChoice]
    let draft: AnswersDraft

    var body: some View {
        if !choices.isEmpty {
            VStack(alignment: .leading, spacing: Spacing.none) {
                if let title {
                    AvoidGroupHeader(title: title)
                }
                ChoiceList(choices: choices, isSelected: isSelected) { choice in
                    if let id = choice.optionID {
                        draft.answers.toggleAvoid(id)
                    }
                }
            }
        }
    }

    private func isSelected(_ choice: TickChoice) -> Bool {
        guard let id = choice.optionID else {
            return false
        }
        return draft.answers.avoid.contains(id)
    }
}

#Preview {
    AvoidGroup(
        title: .questionAvoidGroupChoices,
        choices: [TickChoice(optionID: "a", name: "First"), TickChoice(optionID: "b", name: "Second")],
        draft: .preview()
    )
    .background(ColorRole.paper.color)
}
