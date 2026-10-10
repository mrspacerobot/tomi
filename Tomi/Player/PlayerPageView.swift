import SwiftUI

/// The page of the player on screen.
struct PlayerPageView: View {
    let model: PlayerModel

    var body: some View {
        switch model.page {
        case .ingredients: IngredientsPage(model: model)
        case .step(let position): StepPage(step: model.dish.steps[position], number: position + 1)
        case .quiz: QuizPage(model: model)
        }
    }
}
