import SwiftUI
import TomiCore

/// Cooking days a week, kept inside `CookProfile.weeklyGoalRange` by `CookProfile.setWeeklyGoal`.
struct WeeklyGoalStepper: View {
    let draft: AnswersDraft
    @Environment(\.usesShowQuestionStyle) private var showStyle

    var body: some View {
        QuestionStepperCard {
            Stepper(value: goal, in: CookProfile.weeklyGoalRange) {
                Text(.questionExperienceGoal(draft.answers.weeklyGoal))
                    .textStyle(captionStyle)
            }
            .accessibilityIdentifier("weekly-goal")
        }
    }

    private var captionStyle: TextStyle {
        if showStyle { return .showBodyStrong }
        return .body
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
