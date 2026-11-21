import SwiftUI
import TomiCore

/// One step of the recipe: its number, its text as the server wrote it, and its time, heat and safety points.
struct RecipeStepRow: View {
    let step: AdaptedStep

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.xxSmall) {
            Text(.playerStep(step.number))
                .textStyle(.showLabel, color: .showMuted)
                .textCase(.uppercase)
            Text(verbatim: step.text)
                .textStyle(.showText)
            RecipeStepNotes(step: step)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, Spacing.xSmall)
        .accessibilityElement(children: .combine)
        .accessibilityIdentifier("suggestion-step-\(step.number)")
    }
}
