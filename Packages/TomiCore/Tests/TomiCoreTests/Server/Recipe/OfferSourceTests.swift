import Testing

@testable import TomiCore

/// The reading helpers for the source recipe: units, omitted parts and the names of what was checked.
@Suite struct OfferSourceTests {
    let offer = Offer.sample(checked: CheckedRestrictions(diet: "vegan", avoid: ["nuts", "unlisted"]))

    @Test func timesInKnownUnitsBecomeDurations() {
        let range = SourceTime(shortest: 4, longest: 6, unit: "minute")
        #expect(range.shortestDuration == .seconds(240))
        #expect(range.longestDuration == .seconds(360))
        #expect(SourceTime(shortest: 30, longest: 30, unit: "second").shortestDuration == .seconds(30))
        #expect(SourceTime(shortest: 1, longest: 1, unit: "hour").shortestDuration == .seconds(3600))
    }

    @Test func aTimeInAnUnknownUnitIsNotShown() {
        let odd = SourceTime(shortest: 2, longest: 2, unit: "fortnight")
        #expect(odd.shortestDuration == nil)
        #expect(odd.longestDuration == nil)
    }

    @Test func amountsInTheLessonUnitsAreMeasured() {
        #expect(SourceAmount(value: 30, unit: "gram").measured == Amount(30, .gram))
        #expect(SourceAmount(value: 5, unit: "piece").measured == Amount(5, .piece))
        #expect(SourceAmount(value: 2, unit: "clove").measured == nil)
        #expect(SourceAmount(value: 2, unit: "pinch").measured == nil)
    }

    @Test func aRatioKnowsWhatItCountsIn() {
        #expect(SwapRatio(standIn: 1, original: 1, by: "volume").basis == .volume)
        #expect(SwapRatio(standIn: 1, original: 1, by: "weight").basis == .weight)
        #expect(SwapRatio(standIn: 1, original: 1, by: "count").basis == .count)
        #expect(SwapRatio(standIn: 1, original: 1, by: "mood").basis == nil)
    }

    @Test func clovesAreCountedApart() {
        #expect(SourceAmount(value: 2, unit: "clove").wholeCloves == 2)
        #expect(SourceAmount(value: 0.5, unit: "clove").wholeCloves == nil)
        #expect(SourceAmount(value: 2, unit: "gram").wholeCloves == nil)
    }

    @Test func anOmittedPartIsNamedAfterTheIngredientOfThatPart() {
        #expect(offer.omittedNames == ["cream"])
    }

    @Test func anOmittedPartNoLineNamesIsMadeReadable() {
        let plan = GraphJSON.plan.replacing(#"["enrichment"]"#, with: #"["fresh-herbs"]"#)
        let other = try? ServerJSON.decode(Offer.self, from: GraphJSON.offer(plan: plan))
        #expect(other?.omittedNames == ["fresh herbs"])
    }

    @Test func whatWasCheckedIsNamedFromTheServersListsOrMadeReadable() {
        var options = LibraryOptions()
        options.diets = [DescribedOption(id: "vegan", name: "Vegan", summary: "No animals")]
        options.avoidItems = [AvoidOption(id: "nuts", name: "Nuts", kind: .allergen)]
        #expect(options.names(checkedFor: offer.checked) == ["Vegan", "Nuts", "unlisted"])
        let nothing = CheckedRestrictions(diet: nil, avoid: [])
        #expect(options.names(checkedFor: nothing).isEmpty)
    }
}
