import SwiftUI

/// The way on after the last step: the quiz when the teaching has one, otherwise back to the recipe.
struct CookingStepsEnd: View {
    let session: CookingSession
    let recorder: CookRecorder
    @Binding var path: [HomeRoute]
    @State private var saveFailed = false

    var body: some View {
        Group {
            if session.quiz == nil {
                Button(action: saveAndContinue) { Text(.cookingStepsFinish).frame(maxWidth: .infinity) }
                    .buttonStyle(.tomiSecondary)
                    .accessibilityIdentifier("cooking-steps-finish")
            } else {
                Button(action: saveAndContinue) { Text(.cookingQuizOpen).frame(maxWidth: .infinity) }
                    .buttonStyle(.tomiPrimary)
                    .accessibilityIdentifier("cooking-quiz-open")
            }
        }
        .modifier(CookingSaveFailure(showing: $saveFailed, retry: saveAndContinue))
    }

    private func saveAndContinue() {
        guard recorder.finish() else {
            saveFailed = true
            return
        }
        if session.quiz == nil {
            path.returnToSuggestion()
        } else {
            path.append(.quiz(session))
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
