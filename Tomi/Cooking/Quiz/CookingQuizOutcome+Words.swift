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

    /// The rule down the note: cobalt for right, red for wrong or a problem, as in the mockup.
    var rule: ColorRole {
        switch self {
        case .right: .cobalt
        case .wrong, .problem: .stampRed
        }
    }

    var identifier: String {
        switch self {
        case .right, .wrong: "cooking-quiz-verdict"
        case .problem: "cooking-quiz-problem"
        }
    }
}
