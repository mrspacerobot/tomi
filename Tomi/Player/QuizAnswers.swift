import SwiftUI

/// The answers of the question as tick rows. The first tap is the answer.
struct QuizAnswers: View {
    let model: PlayerModel

    var body: some View {
        ForEach(Array(model.dish.quiz.answers.enumerated()), id: \.offset) { position, answer in
            TickRow(name: LessonText.resolved(answer), isSelected: model.chosenAnswer == position) {
                model.choose(position)
            }
            .accessibilityIdentifier("player-answer-" + String(position))
        }
    }
}
