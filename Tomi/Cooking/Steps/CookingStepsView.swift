import SwiftUI
import TomiCore

/// The adapted recipe, one step at a time, exactly as the server wrote it: its text, its time, its heat and its
/// safety points. Nothing is added to a step. Timers, saved progress and rewards belong to later slices.
struct CookingStepsView: View {
    let suggestion: Suggestion
    @Binding var path: [HomeRoute]
    @State private var walk: StepWalk?

    init(suggestion: Suggestion, path: Binding<[HomeRoute]>) {
        self.suggestion = suggestion
        self._path = path
        _walk = State(initialValue: StepWalk(steps: suggestion.recipe.steps))
    }

    var body: some View {
        ScrollView { content }
            .background(ColorRole.paper.color)
            .navigationTitle(Text(.cookingStepsTitle))
            .navigationBarTitleDisplayMode(.inline)
            .accessibilityIdentifier("cooking-steps")
    }

    @ViewBuilder private var content: some View {
        if let current = Binding($walk) {
            CookingStepPage(title: suggestion.title, walk: current, path: $path)
        } else {
            CookingNoSteps(path: $path)
        }
    }
}
