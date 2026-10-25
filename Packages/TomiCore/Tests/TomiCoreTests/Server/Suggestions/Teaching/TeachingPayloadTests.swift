import Testing

@testable import TomiCore

@Suite struct TeachingPayloadTests {
    @Test func liveBackendFixturePreservesGraphTextAndQuestionCount() throws {
        let suggestion = try ServerJSON.decode(Suggestion.self, from: TeachingJSON.liveSuggestion)
        #expect(suggestion.canOfferTeaching)
        #expect(suggestion.teaching?.graphVersion == "2026.10.22-8aa9532")
        #expect(suggestion.teaching?.technique.name == "Scramble")
        #expect(suggestion.teaching?.introduction.concept == "Gentle curds")
        #expect(suggestion.teaching?.quiz?.count == 4)
    }

    @Test func anUnreviewedProductionQuestionOnlyRemovesTheQuiz() throws {
        let payload = TeachingJSON.productionWithDraftQuestion
        let suggestion = try ServerJSON.decode(Suggestion.self, from: payload)
        #expect(suggestion.teaching?.graphChannel == .production)
        #expect(suggestion.teaching?.introduction.concept == "Gentle curds")
        #expect(suggestion.teaching?.quiz == nil)
    }

    @Test(arguments: [TeachingJSON.duplicateChoices, TeachingJSON.emptyQuestionID, TeachingJSON.blankQuestion])
    func malformedQuestionDropsQuizOnly(_ payload: String) throws {
        let suggestion = try ServerJSON.decode(Suggestion.self, from: payload)
        #expect(suggestion.teaching?.introduction.concept == "Gentle curds")
        #expect(suggestion.teaching?.quiz == nil)
        #expect(suggestion.title == "Soft scrambled eggs")
    }

    @Test(arguments: TeachingJSON.unsupportedPayloads)
    func unsupportedTeachingIsDroppedButRecipeRemains(_ payload: String) throws {
        let suggestion = try ServerJSON.decode(Suggestion.self, from: payload)
        #expect(suggestion.teaching == nil)
        #expect(suggestion.title == "Soft scrambled eggs")
    }
}
