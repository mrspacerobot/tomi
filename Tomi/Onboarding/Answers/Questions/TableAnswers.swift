import SwiftUI
import TomiCore

/// Grams or cups, from the server's list, and how many people eat most nights.
struct TableAnswers: View {
    let draft: AnswersDraft

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.large) {
            ChoiceList(choices: choices, isSelected: isSelected) { choice in
                draft.answers.units = Self.units(of: choice)
            }
            ServingsStepper(draft: draft)
            WeeklyGoalStepper(draft: draft)
        }
    }

    private var choices: [TickChoice] {
        let known = draft.options.units.filter { Units(rawValue: $0.id.rawValue) != nil }
        return known.map { TickChoice(optionID: $0.id, name: $0.name, note: $0.summary) }
    }

    private func isSelected(_ choice: TickChoice) -> Bool {
        Self.units(of: choice) == draft.answers.units(for: .current)
    }

    private static func units(of choice: TickChoice) -> Units? {
        guard let id = choice.optionID else {
            return nil
        }
        return Units(rawValue: id.rawValue)
    }
}

#Preview {
    TableAnswers(draft: .preview())
        .background { ShowStage() }
}
