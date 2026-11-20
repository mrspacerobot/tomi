import SwiftUI

/// A recipe that arrived with no steps. That is never read as "nothing to do": the cook is told, and goes back.
struct CookingNoSteps: View {
    @Binding var path: [HomeRoute]

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.xLarge) {
            Text(.cookingStepsNone).textStyle(.showLede)
            CookingReturnButton(path: $path, words: .cookingStepsFinish, identifier: "cooking-steps-finish")
        }
        .padding(Spacing.screenMargin)
    }
}
