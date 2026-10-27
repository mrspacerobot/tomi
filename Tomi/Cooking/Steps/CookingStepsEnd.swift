import SwiftUI

/// The way on after the last step: the quiz when the teaching has one, otherwise back to the recipe.
struct CookingStepsEnd: View {
    let session: CookingSession
    let recorder: CookRecorder
    @Binding var path: [HomeRoute]

    var body: some View {
        if session.quiz == nil {
            CookingReturnButton(path: $path, words: .cookingStepsFinish, identifier: "cooking-steps-finish") {
                recorder.finish()
            }
        } else {
            Button {
                recorder.finish()
                path.append(.quiz(session))
            } label: {
                Text(.cookingQuizOpen).frame(maxWidth: .infinity)
            }
            .buttonStyle(.tomiPrimary)
            .accessibilityIdentifier("cooking-quiz-open")
        }
    }
}

#Preview {
    @Previewable @State var path: [HomeRoute] = []
    if let suggestion = PreviewSuggestion.make() {
        CookingStepsEnd(
            session: CookingSession(suggestion: suggestion),
            recorder: CookRecorder(session: CookingSession(suggestion: suggestion), flow: .preview()),
            path: $path
        ).padding()
    }
}
