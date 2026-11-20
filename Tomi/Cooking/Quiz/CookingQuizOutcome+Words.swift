import Foundation
import SwiftUI

extension CookingQuizOutcome {
    /// The first line of the note. It says the state in words, so the colour of the rule is never the only sign.
    var title: LocalizedStringResource {
        switch self {
        case .right: .cookingQuizRight
        case .wrong: .cookingQuizWrong
        case .problem(let problem): problem.title
        }
    }

    var haptic: ShowHaptic? {
        switch self {
        case .right: .correctAnswer
        case .wrong: .retryAnswer
        case .problem: nil
        }
    }

    var identifier: String {
        switch self {
        case .right, .wrong: "cooking-quiz-verdict"
        case .problem: "cooking-quiz-problem"
        }
    }
}
