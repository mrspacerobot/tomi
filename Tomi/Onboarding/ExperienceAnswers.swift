import SwiftUI
import TomiCore

/// How much the cook already cooks, from the server's list, and how many days a week they want to cook.
/// Only answers this build understands are shown, because only those can be kept in the profile.
struct ExperienceAnswers: View {
    let draft: AnswersDraft
    @Environment(\.usesShowQuestionStyle) private var showStyle

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.large) {
            ChoiceList(choices: choices, isSelected: isSelected) { choice in
                if let experience = Self.experience(of: choice) {
                    draft.answers.experience = experience
                }
            }
            if !showStyle { WeeklyGoalStepper(draft: draft) }
        }
    }

    private var choices: [TickChoice] {
        let known = draft.options.experience.filter { Experience(rawValue: $0.id.rawValue) != nil }
        return known.map { TickChoice(optionID: $0.id, name: $0.name, note: $0.summary) }
    }

    private func isSelected(_ choice: TickChoice) -> Bool {
        Self.experience(of: choice) == draft.answers.experience
    }

    private static func experience(of choice: TickChoice) -> Experience? {
        guard let id = choice.optionID else {
            return nil
        }
        return Experience(rawValue: id.rawValue)
    }
}

#Preview {
    ExperienceAnswers(draft: .preview())
        .background(ColorRole.paper.color)
}
