import SwiftUI

/// The one question of the lesson. After an answer, the explanation; a wrong answer costs nothing.
struct QuizPage: View {
    let model: PlayerModel

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.medium) {
            Text(verbatim: LessonText.resolved(model.dish.quiz.question))
                .textStyle(.displayM)
                .accessibilityIdentifier("player-quiz")
            ForEach(Array(model.dish.quiz.answers.enumerated()), id: \.offset) { position, answer in
                TickRow(name: LessonText.resolved(answer), isSelected: model.chosenAnswer == position) {
                    model.choose(position)
                }
                .accessibilityIdentifier("player-answer-" + String(position))
            }
            if model.chosenAnswer != nil {
                Text(verbatim: LessonText.resolved(model.dish.quiz.explanation))
                    .textStyle(.body)
            }
        }
    }
}
