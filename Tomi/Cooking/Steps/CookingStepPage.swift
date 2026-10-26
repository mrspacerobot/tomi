import SwiftUI
import TomiCore

/// One step: where the cook is in the recipe, the step as the server wrote it, and the way on.
struct CookingStepPage: View {
    let title: String
    @Binding var walk: StepWalk
    @Binding var path: [HomeRoute]

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.xLarge) {
            Text(verbatim: title).textStyle(.displayM)
            CookingStepProgress(position: walk.position, count: walk.count)
            Text(verbatim: walk.current.text)
                .textStyle(.step)
                .accessibilityIdentifier("cooking-step-text")
            RecipeStepNotes(step: walk.current)
            CookingStepControls(walk: $walk, path: $path)
        }
        .padding(Spacing.screenMargin)
    }
}
