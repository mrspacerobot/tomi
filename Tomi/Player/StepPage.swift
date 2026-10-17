import SwiftUI
import TomiCore

/// One step: its number, what to do and the tip. Drawn scenes and timers are the player's own issues.
struct StepPage: View {
    let step: LessonStep
    let number: Int

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.medium) {
            Text(.playerStep(number))
                .textStyle(.label)
                .textCase(.uppercase)
            Text(verbatim: LessonText.resolved(step.text))
                .textStyle(.step)
                .accessibilityIdentifier("player-step")
            if let tip = step.tip {
                Text(verbatim: LessonText.resolved(tip))
                    .textStyle(.description)
            }
        }
    }
}
