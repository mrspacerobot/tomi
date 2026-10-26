import Testing

@testable import TomiCore

/// Teaching schema 2: quiz questions arrive without their answers, which only the server holds.
@Suite struct TeachingQuizSchemaTests {
    @Test func theSchemaTwoExampleKeepsEveryQuestion() throws {
        let quiz = try #require(
            try ServerJSON.decode(Suggestion.self, from: TeachingJSON.liveSuggestion).teaching?.quiz
        )
        #expect(quiz.map(\.id) == TeachingQuizExample.ids)
        #expect(quiz.map(\.question) == TeachingQuizExample.questions)
        #expect(quiz.map(\.choices) == TeachingQuizExample.choices)
        #expect(quiz.allSatisfy { $0.tier == .drafted })
    }

    @Test func aQuestionHoldsNoAnswerAndNoExplanation() throws {
        let quiz = try #require(
            try ServerJSON.decode(Suggestion.self, from: TeachingJSON.liveSuggestion).teaching?.quiz
        )
        let labels = Mirror(reflecting: try #require(quiz.first)).children.map(\.label)
        #expect(labels == ["id", "question", "choices", "tier"])
    }

    @Test(arguments: ["Tomi/Resources/Fixtures", "Packages/TomiCore/Tests/TomiCoreTests/Server/Suggestions/Teaching"])
    func noFixtureCarriesAnAnswer(folder: String) throws {
        for path in try Repository.paths(under: folder, ending: ".json") {
            let text = try Repository.text(path)
            #expect(!text.contains("answerIndex"), "\(path)")
            #expect(!text.contains("explanation"), "\(path)")
        }
    }

    @Test func theAppAndTheRulesShareTheSameExample() throws {
        let app = try Repository.text("Tomi/Resources/Fixtures/teaching-suggestion.json")
        #expect(app == TeachingJSON.liveSuggestion)
    }

    /// Until the server sends schema 2, schema 1 is still read. Its answers are never read, so never trusted.
    @Test func schemaOneIsStillReadAndItsAnswersAreIgnored() throws {
        let suggestion = try ServerJSON.decode(Suggestion.self, from: TeachingQuizJSON.schemaOneWithAnswers)
        #expect(suggestion.canOfferTeaching)
        #expect(suggestion.teaching?.quiz?.map(\.id) == TeachingQuizExample.ids)
    }

    @Test(arguments: [[], ["Small, soft, creamy curds."]])
    func fewerThanTwoChoicesDropsTheQuizOnly(choices: [String]) throws {
        let payload = try TeachingQuizJSON.firstQuestion(choices: choices)
        let suggestion = try ServerJSON.decode(Suggestion.self, from: payload)
        #expect(suggestion.teaching?.introduction.concept == "Gentle curds")
        #expect(suggestion.teaching?.quiz == nil)
        #expect(suggestion.title == "Soft scrambled eggs")
    }
}
