import Foundation
import Testing

@testable import TomiCore

/// Suggestions as `POST /v1/lessons/suggest` sends them (graph recipes).
@Suite struct SpecialsDecodingTests {
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

    @Test func theOriginalRecipeKeepsItsOwnInstructionsUnchanged() throws {
        let source = try ServerJSON.decode(Suggestion.self, from: GraphJSON.suggestion()).originalRecipe
        #expect(source.steps.map(\.text) == ["Whisk the eggs.", "Stir over low heat.", "Take it off the heat."])
        #expect(source.ingredients.map(\.thing.rawValue).first == "ingredient/egg")
        #expect(source.ingredients.first?.amount == RecipeAmount(value: 5, unit: "piece"))
        #expect(source.equipment == ["equipment/saucepan", "equipment/whisk"])
        #expect(source.yields == RecipeAmount(value: 2, unit: "serving"))
    }

    @Test func stepTimesReadAsOneValueOrARange() throws {
        let steps = try ServerJSON.decode(Suggestion.self, from: GraphJSON.suggestion()).originalRecipe.steps
        #expect(steps[0].time == nil)
        #expect(steps[1].time == StepTime(shortest: 4, longest: 6, unit: "minute"))
        #expect(steps[2].time == StepTime(shortest: 30, longest: 30, unit: "second"))
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
}
