import SwiftUI

/// The end of the quiz. No score and no XP: the server keeps the first pick of each question.
struct CookingQuizDone: View {
    @Binding var path: [HomeRoute]

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.xLarge) {
            Text(.cookingQuizDoneTitle)
                .textStyle(.displayM)
                .accessibilityAddTraits(.isHeader)
                .accessibilityIdentifier("cooking-quiz-done")
            Text(.cookingQuizDoneMessage).textStyle(.body)
            CookingReturnButton(path: $path, words: .cookingStepsFinish, identifier: "cooking-quiz-finish")
        }
        .padding(Spacing.screenMargin)
    }
}

#Preview {
    @Previewable @State var path: [HomeRoute] = []
    CookingQuizDone(path: $path).background(ColorRole.paper.color)
}
