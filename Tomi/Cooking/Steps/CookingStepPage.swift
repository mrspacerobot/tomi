import SwiftUI
import TomiCore

/// One step: where the cook is in the recipe, the step as the server wrote it, and the way on.
struct CookingStepPage: View {
    let session: CookingSession
    @Binding var walk: StepWalk
    @Binding var path: [HomeRoute]

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.xLarge) {
            Text(verbatim: session.suggestion.title).textStyle(.displayM)
            CookingProgress(words: .cookingStepsProgress(walk.position, walk.count), marks: walk.marks)
            Text(verbatim: walk.current.text)
                .textStyle(.step)
                .accessibilityIdentifier("cooking-step-text")
            RecipeStepNotes(step: walk.current)
            CookingStepControls(session: session, walk: $walk, path: $path)
        }
        .padding(Spacing.screenMargin)
    }
}
