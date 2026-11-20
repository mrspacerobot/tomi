import SwiftUI
import TomiCore

/// The way on from a step: the next one, after the last the quiz or back to the recipe, and back one step except at
/// the first.
struct CookingStepControls: View {
    let session: CookingSession
    let recorder: CookRecorder
    @Binding var walk: StepWalk
    @Binding var path: [HomeRoute]

    var body: some View {
        VStack(spacing: Spacing.small) {
            forward
            if !walk.isFirst {
                Button {
                    walk = walk.steppedBack()
                } label: {
                    Text(.cookingStepsPrevious).frame(maxWidth: .infinity)
                }
                .buttonStyle(ShowSecondaryButtonStyle())
                .accessibilityIdentifier("cooking-step-previous")
            }
        }
    }

    @ViewBuilder private var forward: some View {
        if walk.isLast {
            CookingStepsEnd(session: session, recorder: recorder, path: $path)
        } else {
            Button {
                walk = walk.advanced()
            } label: {
                Text(.cookingStepsNext).frame(maxWidth: .infinity)
            }
            .buttonStyle(ShowPrimaryButtonStyle())
            .accessibilityIdentifier("cooking-step-next")
        }
    }
}
