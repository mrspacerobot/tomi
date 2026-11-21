import Foundation
import TomiCore

/// The first questions, one at a time, and the answers sent to the server at the end.
@Observable
final class OnboardingModel {
    let questions = ProfileQuestion.onboarding
    private(set) var position = 0
    private(set) var showsWelcome = true
    let draft: AnswersDraft
    let saver: AnswersSaver

    init(profile: ProfileModel, options: LibraryOptions) {
        draft = AnswersDraft(answers: profile.profile, options: options, api: profile.api)
        saver = AnswersSaver(profile: profile)
    }

    var question: ProfileQuestion {
        questions[position]
    }

    var isLastQuestion: Bool {
        position == questions.count - 1
    }

    var canGoBack: Bool {
        position > 0
    }

    func start() {
        showsWelcome = false
    }

    func next() {
        position = min(position + 1, questions.count - 1)
    }

    func back() {
        if position == 0 {
            showsWelcome = true
        } else {
            position -= 1
        }
    }

    /// Sends every answer, marked as done. True when the server has them.
    func finish(confirmed: Bool) async -> Bool {
        var answers = draft.answers
        answers.isOnboardingDone = true
        return await saver.save(answers, confirmed: confirmed)
    }
}
