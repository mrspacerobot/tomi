import SwiftUI
import TomiCore

struct CookingLiveStep: View {
    let step: AdaptedStep

    var body: some View {
        ShowCard {
            VStack(alignment: .leading, spacing: ShowSize.gap) {
                Text(verbatim: step.text)
                    .textStyle(.showBodyStrong)
                    .accessibilityIdentifier("cooking-step-text")
                RecipeStepNotes(step: step)
            }
        }
    }
}

#Preview {
    if let step = PreviewSuggestion.make()?.recipe.steps.first {
        CookingLiveStep(step: step).padding().background { ShowStage() }
    }
}
