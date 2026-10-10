import Foundation
import OSLog
import TomiCore

/// Cooking one lesson from the file on the phone, so it works without a connection.
/// The place is bookmarked at every page, and the cook is logged when it ends.
@Observable
final class PlayerModel {
    static let logger = Logger(category: .progress)

    let dish: Lesson
    let offer: Offer
    let profile: CookProfile
    private(set) var page = PlayerPage.ingredients
    private(set) var chosenAnswer: Int?
    let store: any ProgressStore

    init(dish: Lesson, offer: Offer, flow: AppFlowModel) {
        self.dish = dish
        self.offer = offer
        profile = flow.profile.profile
        store = flow.services.store
    }

    var units: Units {
        profile.units(for: .current)
    }

    func next() {
        switch page {
        case .ingredients: show(.step(0))
        case .step(let position) where position + 1 < dish.steps.count: show(.step(position + 1))
        case .step: show(.quiz)
        case .quiz: break
        }
    }

    func choose(_ answer: Int) {
        if chosenAnswer == nil {
            chosenAnswer = answer
        }
    }

    var answeredRight: Bool {
        chosenAnswer != nil && chosenAnswer == dish.quiz.correctAnswer
    }

    private func show(_ next: PlayerPage) {
        page = next
        if case .step(let position) = next {
            bookmark(position)
        }
    }
}
