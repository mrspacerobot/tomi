import Foundation
import Testing

@testable import TomiCore

/// A suggestion asks its quiz only when its teaching may be offered, under the entry id made when cooking began.
@Suite struct SuggestionQuizTests {
    let entryID = UUID(uuidString: "4e2c2a0e-7e6b-4c7a-9c2b-6e0a3d1f9a11")!

    @Test func theTeachingQuizIsAskedForTheRecipeAndItsGraphVersion() throws {
        let suggestion = try ServerJSON.decode(Suggestion.self, from: TeachingJSON.liveSuggestion)
        let round = try #require(suggestion.quiz(entryID: entryID))
        #expect(round.sitting == QuizJSON.sitting)
        #expect(round.questions.map(\.id) == TeachingQuizExample.ids)
    }

    @Test func aSuggestionWithoutTeachingHasNoQuiz() {
        #expect(Suggestion.sample(checked: CheckedRestrictions(diet: nil, avoid: [])).quiz(entryID: entryID) == nil)
    }

    @Test func aChangedRecipeHasNoQuiz() throws {
        let changed = TeachingJSON.liveSuggestion.replacingOccurrences(
            of: #""swaps": []"#,
            with: "\"swaps\": [\(GraphJSON.swap)]"
        )
        let suggestion = try ServerJSON.decode(Suggestion.self, from: changed)
        #expect(!suggestion.canOfferTeaching)
        #expect(suggestion.quiz(entryID: entryID) == nil)
    }

    @Test func aProductionQuizWithADraftQuestionIsNotAsked() throws {
        let suggestion = try ServerJSON.decode(Suggestion.self, from: TeachingJSON.productionWithDraftQuestion)
        #expect(suggestion.quiz(entryID: entryID) == nil)
    }
}
