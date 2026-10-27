import Foundation
import OSLog
import TomiCore

/// Cooking one lesson from the file on the phone, so it works without a connection.
/// The place is bookmarked at every page, and the cook is logged when it ends.
@Observable
final class PlayerModel {
    static let logger = Logger(category: .progress)

    let dish: Lesson
    let brief: PlayerBrief
    let profile: CookProfile
    private(set) var page = PlayerPage.ingredients
    private(set) var chosenAnswer: Int?
    let store: any ProgressStore
    let uploader: CookEntryUploader
    let auth: any AuthService
    /// The zone a cook is saved in. The phone's own zone while cooking; a test sets a fixed one.
    var cookingZone = TimeZone.current

    init(dish: Lesson, brief: PlayerBrief, flow: AppFlowModel) {
        self.dish = dish
        self.brief = brief
        profile = flow.profile.profile
        store = flow.services.store
        uploader = flow.uploader
        auth = flow.services.auth
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
