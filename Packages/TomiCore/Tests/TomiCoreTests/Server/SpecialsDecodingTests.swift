import Foundation
import Testing

@testable import TomiCore

/// Offers as `POST /v1/lessons/suggest` sends them (graph recipes).
@Suite struct SpecialsDecodingTests {
    @Test func anOfferIsReadWithItsSafePlanAndCheck() throws {
        let offer = try ServerJSON.decode(Offer.self, from: GraphJSON.offer())
        #expect(offer.recipeID == "recipe/soft-scrambled-eggs")
        #expect(offer.title == "Soft scrambled eggs")
        #expect(offer.skill == OfferSkill(id: "eggs", name: "Eggs"))
        #expect(offer.level == NamedLevel(number: 1, name: "Soft"))
        #expect(offer.reason == "Quick tonight.")
        #expect(offer.checked == CheckedRestrictions(diet: "vegan", avoid: ["nuts"]))
    }

    @Test func aSafePlanIsReadWithAllFiveLists() throws {
        let plan = try ServerJSON.decode(Offer.self, from: GraphJSON.offer()).safePlan
        #expect(plan.ingredients.map(\.id) == ["ingredient/egg", "ingredient/oil"])
        #expect(plan.omittedParts == ["enrichment"])
        #expect(plan.missing.map(\.name) == ["Oil"])
        #expect(plan.equipment.map(\.name) == ["Whisk"])
        #expect(plan.substitutions.count == 1)
    }

    @Test func aSubstitutionKeepsItsRatioAndCaveat() throws {
        let offer = try ServerJSON.decode(Offer.self, from: GraphJSON.offer())
        let swap = try #require(offer.safePlan.substitutions.first)
        #expect(swap.removed.name == "Butter")
        #expect(swap.added.name == "Oil")
        #expect(swap.ratio == SwapRatio(standIn: 1, original: 1, by: "volume"))
        #expect(swap.caveat == "No butter aroma.")
    }

    @Test func aSubstitutionMayHaveNoRatioAndNoCaveat() throws {
        let plain = GraphJSON.plan.replacing(GraphJSON.ratio, with: #""ratio": null"#)
            .replacing(GraphJSON.caveat, with: #""caveat": null"#)
        let offer = try ServerJSON.decode(Offer.self, from: GraphJSON.offer(plan: plain))
        #expect(offer.safePlan.substitutions.first?.ratio == nil)
        #expect(offer.safePlan.substitutions.first?.caveat == nil)
    }

    @Test func theSourceRecipeKeepsItsOwnInstructionsUnchanged() throws {
        let source = try ServerJSON.decode(Offer.self, from: GraphJSON.offer()).sourceRecipe
        #expect(source.steps.map(\.text) == ["Whisk the eggs.", "Stir over low heat.", "Take it off the heat."])
        #expect(source.ingredients.map(\.thing.rawValue).first == "ingredient/egg")
        #expect(source.ingredients.first?.amount == SourceAmount(value: 5, unit: "piece"))
        #expect(source.equipment == ["equipment/saucepan", "equipment/whisk"])
        #expect(source.yields == SourceAmount(value: 2, unit: "serving"))
    }

    @Test func stepTimesReadAsOneValueOrARange() throws {
        let steps = try ServerJSON.decode(Offer.self, from: GraphJSON.offer()).sourceRecipe.steps
        #expect(steps[0].time == nil)
        #expect(steps[1].time == SourceTime(shortest: 4, longest: 6, unit: "minute"))
        #expect(steps[2].time == SourceTime(shortest: 30, longest: 30, unit: "second"))
    }

    /// A newer server may add fields anywhere; the app reads what it knows.
    @Test func unknownFieldsAreIgnored() throws {
        let plan = GraphJSON.plan.replacing(#""omittedParts""#, with: #""futureNote": 1, "omittedParts""#)
        let offer = try ServerJSON.decode(Offer.self, from: GraphJSON.offer(plan: plan, extra: #", "newer": [1]"#))
        #expect(offer.safePlan.omittedParts == ["enrichment"])
    }
}
