import Foundation
import TomiCore

/// One cook of a suggestion, from the moment the steps begin. The entry id is made then and kept for the whole
/// cook: the quiz picks are recorded under it, and the finish will send it as the cook entry's id (#28).
struct CookingSession: Hashable {
    let suggestion: Suggestion
    let entryID: UUID

    init(suggestion: Suggestion, entryID: UUID = UUID()) {
        self.suggestion = suggestion
        self.entryID = entryID
    }

    /// The quiz after the steps, or nil when the suggestion's teaching has none to ask.
    var quiz: QuizRound? {
        suggestion.quiz(entryID: entryID)
    }
}
