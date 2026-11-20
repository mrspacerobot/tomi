import SwiftUI
import TomiCore

/// What a step adds to its text, when it has any: how long, how hot, and the safety points the server names.
/// The safety points are the server's own, made readable; the app words none of them.
struct RecipeStepNotes: View {
    let step: AdaptedStep

    var body: some View {
        if let time = step.time, let words = StepTimeFormat.text(for: time) {
            Text(verbatim: words)
                .textStyle(.showNote)
        }
        if let temperature = step.temperature, let words = StepTemperatureFormat.text(for: temperature) {
            Text(verbatim: words)
                .textStyle(.showNote)
        }
        if !step.safetyPoints.isEmpty {
            Text(.suggestionStepSafety(step.safetyPointWords.formatted(.list(type: .and))))
                .textStyle(.showNote)
        }
    }
}
