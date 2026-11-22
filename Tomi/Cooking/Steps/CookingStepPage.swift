import SwiftUI
import TomiCore

/// One step: where the cook is in the recipe, the step as the server wrote it, and the way on.
struct CookingStepPage: View {
    let session: CookingSession
    let recorder: CookRecorder
    @Binding var walk: StepWalk
    @Binding var path: [HomeRoute]

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.xLarge) {
            ShowLowerThird(title: .showtimeLive)
            Text(verbatim: session.suggestion.title).textStyle(.showTitle)
            CookingProgress(words: .cookingStepsProgress(walk.position, walk.count), marks: walk.marks)
            CookingLiveStep(step: walk.current)
            CookingStepControls(session: session, recorder: recorder, walk: $walk, path: $path)
        }
        .padding(Spacing.screenMargin)
    }
}
