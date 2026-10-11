import Foundation
import TomiCore

/// The first questions, one at a time, and the answers sent to the server at the end.
@Observable
final class OnboardingModel {
    let questions = ProfileQuestion.onboarding
    private(set) var position = 0
    let draft: AnswersDraft
    let saver: AnswersSaver

    init(profile: ProfileModel, options: LibraryOptions) {
        draft = AnswersDraft(answers: profile.profile, options: options)
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

    func next() {
        position = min(position + 1, questions.count - 1)
    }

    func back() {
        position = max(position - 1, 0)
    }

    /// Sends every answer, marked as done. True when the server has them.
    func finish(confirmed: Bool) async -> Bool {
        var answers = draft.answers
        answers.isOnboardingDone = true
        return await saver.save(answers, confirmed: confirmed)
    }
}
