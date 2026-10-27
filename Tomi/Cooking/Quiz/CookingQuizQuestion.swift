import SwiftUI
import TomiCore

/// "Question 1 of 2" over a mark for each question, and the question as the server wrote it.
struct CookingQuizQuestion: View {
    let round: QuizRound

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.small) {
            CookingProgress(words: .cookingQuizProgress(round.position, round.count), marks: round.marks)
            Text(verbatim: round.current.question)
                .textStyle(.displayM)
                .accessibilityAddTraits(.isHeader)
                .accessibilityIdentifier("cooking-quiz-question")
        }
    }
}

#Preview {
    if let round = PreviewSuggestion.make()?.quiz(entryID: UUID()) {
        CookingQuizQuestion(round: round).padding()
    }
}
