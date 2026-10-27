import SwiftUI
import TomiCore

/// The adapted recipe, one step at a time, exactly as the server wrote it: its text, its time, its heat and its
/// safety points. Nothing is added to a step. After the last step comes the quiz, when the teaching has one.
/// Timers, saved progress and rewards belong to later slices.
struct CookingStepsView: View {
    let session: CookingSession
    @Binding var path: [HomeRoute]
    @State private var walk: StepWalk?
    @State private var recorder: CookRecorder

    init(session: CookingSession, flow: AppFlowModel, path: Binding<[HomeRoute]>) {
        self.session = session
        self._path = path
        _recorder = State(initialValue: CookRecorder(session: session, flow: flow))
        _walk = State(initialValue: StepWalk(steps: session.suggestion.recipe.steps))
    }

    var body: some View {
        ScrollView { content }
            .id(walk?.position)
            .background(ColorRole.paper.color)
            .navigationTitle(Text(.cookingStepsTitle))
            .navigationBarTitleDisplayMode(.inline)
            .accessibilityIdentifier("cooking-steps")
            .onDisappear { recorder.stop() }
    }

    @ViewBuilder private var content: some View {
        if let current = Binding($walk) {
            CookingStepPage(session: session, recorder: recorder, walk: current, path: $path)
        } else {
            CookingNoSteps(path: $path)
        }
    }
}
