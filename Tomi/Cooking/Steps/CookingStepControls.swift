import SwiftUI
import TomiCore

/// The way on from a step: the next one, or back to the recipe after the last, and back one step except at the first.
struct CookingStepControls: View {
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
                .buttonStyle(.tomiSecondary)
                .accessibilityIdentifier("cooking-step-previous")
            }
        }
    }

    @ViewBuilder private var forward: some View {
        if walk.isLast {
            CookingReturnButton(path: $path, words: .cookingStepsFinish, identifier: "cooking-steps-finish")
        } else {
            Button {
                walk = walk.advanced()
            } label: {
                Text(.cookingStepsNext).frame(maxWidth: .infinity)
            }
            .buttonStyle(.tomiPrimary)
            .accessibilityIdentifier("cooking-step-next")
        }
    }
}
