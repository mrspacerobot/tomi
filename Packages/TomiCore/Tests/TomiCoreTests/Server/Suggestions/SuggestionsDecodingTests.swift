import Foundation
import Testing

@testable import TomiCore

/// Suggestions as `POST /v1/lessons/suggest` sends them (graph recipes).
@Suite struct SuggestionsDecodingTests {
    @Test func anSuggestionIsReadWithItsSafePlanAndCheck() throws {
        let suggestion = try ServerJSON.decode(Suggestion.self, from: GraphJSON.suggestion())
        #expect(suggestion.recipeID == "recipe/soft-scrambled-eggs")
        #expect(suggestion.title == "Soft scrambled eggs")
        #expect(suggestion.skill == SuggestionSkill(id: "eggs", name: "Eggs"))
        #expect(suggestion.level == NamedLevel(number: 1, name: "Soft"))
        #expect(suggestion.reason == "Quick tonight.")
        #expect(suggestion.checked == CheckedRestrictions(diet: "vegan", avoid: ["nuts"]))
    }

    @Test func aSafePlanIsReadWithAllFiveLists() throws {
        let plan = try ServerJSON.decode(Suggestion.self, from: GraphJSON.suggestion()).safePlan
        #expect(plan.ingredients.map(\.id) == ["ingredient/egg", "ingredient/oil"])
        #expect(plan.omittedParts == ["enrichment"])
        #expect(plan.missing.map(\.name) == ["Oil"])
        #expect(plan.equipment.map(\.name) == ["Whisk"])
        #expect(plan.substitutions.count == 1)
    }

    @Test func aSubstitutionKeepsItsRatioAndCaveat() throws {
        let suggestion = try ServerJSON.decode(Suggestion.self, from: GraphJSON.suggestion())
        let swap = try #require(suggestion.safePlan.substitutions.first)
        #expect(swap.removed.name == "Butter")
        #expect(swap.added.name == "Oil")
        #expect(swap.ratio == SwapRatio(standIn: 1, original: 1, by: "volume"))
        #expect(swap.caveat == "No butter aroma.")
    }

    @Test func aSubstitutionMayHaveNoRatioAndNoCaveat() throws {
        let plain = GraphJSON.plan.replacing(GraphJSON.ratio, with: #""ratio": null"#)
            .replacing(GraphJSON.caveat, with: #""caveat": null"#)
        let suggestion = try ServerJSON.decode(Suggestion.self, from: GraphJSON.suggestion(plan: plain))
        #expect(suggestion.safePlan.substitutions.first?.ratio == nil)
        #expect(suggestion.safePlan.substitutions.first?.caveat == nil)
    }

    /// A newer server may add fields anywhere; the app reads what it knows.
    @Test func unknownFieldsAreIgnored() throws {
        let plan = GraphJSON.plan.replacing(#""omittedParts""#, with: #""futureNote": 1, "omittedParts""#)
        let suggestion = try ServerJSON.decode(
            Suggestion.self,
            from: GraphJSON.suggestion(plan: plan, extra: #", "newer": [1]"#)
        )
        #expect(suggestion.safePlan.omittedParts == ["enrichment"])
    }

    @Test func teachingIsOptionalAndMalformedTeachingDoesNotHideTheRecipe() throws {
        let decoded = try suggestion(with: TeachingJSON.valid)
        #expect(decoded.teaching?.technique.name == "Scramble")
        #expect(decoded.teaching?.introduction.concept == "Gentle curds")
        #expect(!decoded.canOfferTeaching)
        let bad = TeachingJSON.valid.replacing("\"schemaVersion\":1", with: "\"schemaVersion\":2")
        let fallback = try suggestion(with: bad)
        #expect(fallback.teaching == nil)
        #expect(fallback.title == "Soft scrambled eggs")
    }

    @Test func malformedQuizDoesNotHideItsValidIntroduction() throws {
        let decoded = try suggestion(with: TeachingJSON.invalidQuiz)
        #expect(decoded.teaching?.introduction.concept == "Gentle curds")
        #expect(decoded.teaching?.quiz == nil)
    }

    @Test func backendTeachingSuggestionFixtureDecodesWithUnchangedGraphText() throws {
        let suggestion = try ServerJSON.decode(Suggestion.self, from: TeachingJSON.liveSuggestion)
        #expect(suggestion.canOfferTeaching)
        #expect(suggestion.teaching?.graphVersion == "2026.10.22-8aa9532")
        #expect(suggestion.teaching?.technique.name == "Scramble")
        #expect(suggestion.teaching?.introduction.concept == "Gentle curds")
        #expect(suggestion.teaching?.quiz?.count == 4)
    }

    @Test func aProductionQuestionBelowReviewTierIsDroppedWithoutLosingIntroduction() throws {
        let suggestion = try ServerJSON.decode(Suggestion.self, from: TeachingJSON.productionWithDraftQuestion)
        #expect(suggestion.teaching?.introduction.concept == "Gentle curds")
        #expect(suggestion.teaching?.quiz == nil)
    }

    private func suggestion(with teaching: String) throws -> Suggestion {
        let wire = GraphJSON.suggestion().replacing(#""checked": "#, with: teaching + #", "checked": "#)
        return try ServerJSON.decode(Suggestion.self, from: wire)
    }
}
