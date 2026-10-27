import Foundation

extension Suggestion {
    /// The quiz a cook of this suggestion is asked, under the entry id made when cooking began. Nil when its
    /// teaching may not be offered for the recipe as adapted, or has no quiz.
    public func quiz(entryID: UUID) -> QuizRound? {
        guard canOfferTeaching, let teaching, let questions = teaching.quiz else { return nil }
        let sitting = QuizSitting(entryID: entryID, recipeID: recipeID, graphVersion: teaching.graphVersion)
        return QuizRound(sitting: sitting, questions: questions)
    }
}
