import Foundation

extension CookingQuizProblem {
    /// Tomi's words for the problem, first a short line and then what the cook can do.
    var title: LocalizedStringResource {
        switch self {
        case .offline: .cookingQuizOfflineTitle
        case .graphChanged: .cookingQuizGraphChangedTitle
        case .failed: .cookingQuizFailedTitle
        }
    }

    var message: LocalizedStringResource {
        switch self {
        case .offline: .cookingQuizOfflineMessage
        case .graphChanged: .cookingQuizGraphChangedMessage
        case .failed: .cookingQuizFailedMessage
        }
    }
}
