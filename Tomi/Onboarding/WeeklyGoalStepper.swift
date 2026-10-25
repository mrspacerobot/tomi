import SwiftUI
import TomiCore

/// Cooking days a week, kept inside the game's range by `CookProfile.setWeeklyGoal`.
struct WeeklyGoalStepper: View {
    let draft: AnswersDraft

    var body: some View {
        Stepper(value: goal, in: GameRules.weeklyGoalOptions) {
            Text(.questionExperienceGoal(draft.answers.weeklyGoal))
                .textStyle(.body)
        }
        .accessibilityIdentifier("weekly-goal")
    }

    private var goal: Binding<Int> {
        Binding(
            get: { draft.answers.weeklyGoal },
            set: { draft.answers.setWeeklyGoal($0) }
        )
    }
}

#Preview {
    WeeklyGoalStepper(draft: .preview())
        .padding()
}
