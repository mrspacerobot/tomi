import Foundation
import Testing

@testable import TomiCore

/// The reading helpers for the recipe: units and the names of what was checked.
@Suite struct SuggestionSourceTests {
    let suggestion = Suggestion.sample(checked: CheckedRestrictions(diet: "vegan", avoid: ["nuts", "unlisted"]))

    @Test func timesInKnownUnitsBecomeDurations() {
        let range = StepTime(shortest: 4, longest: 6, unit: "minute")
        #expect(range.shortestDuration == .seconds(240))
        #expect(range.longestDuration == .seconds(360))
        #expect(StepTime(shortest: 30, longest: 30, unit: "second").shortestDuration == .seconds(30))
        #expect(StepTime(shortest: 1, longest: 1, unit: "hour").shortestDuration == .seconds(3600))
    }

    @Test func aTimeInAnUnknownUnitIsNotShown() {
        let odd = StepTime(shortest: 2, longest: 2, unit: "fortnight")
        #expect(odd.shortestDuration == nil)
        #expect(odd.longestDuration == nil)
    }

    @Test func amountsInTheLessonUnitsAreMeasured() {
        #expect(RecipeAmount(value: 30, unit: "gram").measured == Amount(30, .gram))
        #expect(RecipeAmount(value: 5, unit: "piece").measured == Amount(5, .piece))
        #expect(RecipeAmount(value: 2, unit: "clove").measured == nil)
        #expect(RecipeAmount(value: 2, unit: "pinch").measured == nil)
    }

    @Test func aRatioKnowsWhatItCountsIn() {
        #expect(SwapRatio(standIn: 1, original: 1, by: "volume").basis == .volume)
        #expect(SwapRatio(standIn: 1, original: 1, by: "weight").basis == .weight)
        #expect(SwapRatio(standIn: 1, original: 1, by: "count").basis == .count)
        #expect(SwapRatio(standIn: 1, original: 1, by: "mood").basis == nil)
    }

    @Test func everyCountedThingIsAWholeNumberOrNothing() {
        for counted in [RecipeAmount.CountUnit.pinch, .sprig, .slice, .leaf, .serving, .clove] {
            #expect(RecipeAmount(value: 3, unit: counted.rawValue).whole(counted) == 3)
            #expect(RecipeAmount(value: 1.5, unit: counted.rawValue).whole(counted) == nil)
            #expect(RecipeAmount(value: 0, unit: counted.rawValue).whole(counted) == nil)
            #expect(RecipeAmount(value: 3, unit: "gram").whole(counted) == nil)
        }
        #expect(RecipeAmount(value: 2, unit: "pinch").whole(.sprig) == nil)
    }

    @Test func kilogramsAndLitresAreMeasuredAndOtherUnitsAreNot() {
        let heavy = RecipeAmount(value: 2, unit: "kilogram").large
        #expect(heavy == Measurement<Dimension>(value: 2, unit: UnitMass.kilograms))
        let wet = RecipeAmount(value: 1.5, unit: "litre").large
        #expect(wet == Measurement<Dimension>(value: 1.5, unit: UnitVolume.liters))
        #expect(RecipeAmount(value: 2, unit: "gram").large == nil)
    }

    @Test func clovesAreCountedApart() {
        #expect(RecipeAmount(value: 2, unit: "clove").wholeCloves == 2)
        #expect(RecipeAmount(value: 0.5, unit: "clove").wholeCloves == nil)
        #expect(RecipeAmount(value: 2, unit: "gram").wholeCloves == nil)
    }

    @Test func whatWasCheckedIsNamedFromTheServersListsOrMadeReadable() {
        var options = LibraryOptions()
        options.diets = [DescribedOption(id: "vegan", name: "Vegan", summary: "No animals")]
        options.avoidItems = [AvoidOption(id: "nuts", name: "Nuts", kind: .allergen)]
        #expect(options.names(checkedFor: suggestion.checked) == ["Vegan", "Nuts", "unlisted"])
        let nothing = CheckedRestrictions(diet: nil, avoid: [])
        #expect(options.names(checkedFor: nothing).isEmpty)
    }
}
