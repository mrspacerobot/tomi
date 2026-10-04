import Testing

@testable import TomiCore

/// The validator's checks on what a cook can choose. The compiler checks none of this,
/// so each rule here is what keeps a mistyped fact from making an avoid item or a diet do nothing.
@Suite struct IngredientRestrictionValidationTests {
    let table = IngredientTable.fixture()
    let dairy = AvoidItem.fixture("dairy", triggeredBy: ["dairy"])
    let vegan = Diet.fixture("vegan", excludes: ["meat", "dairy"])
    let blankText = LocalizedText(["en": " "])

    @Test func aFactIsDeclaredOnlyOnceAndIsNeverBlank() {
        #expect(table.with(facts: ["meat", "dairy", "meat"]).issues.contains(.duplicateFact("meat")))
        #expect(table.with(facts: IngredientTable.fixtureFacts + [""]).issues == [.blankFactID(position: 7)])
    }

    @Test func anAvoidItemIDMayAppearOnlyOnceAndIsNeverBlank() {
        let blank = AvoidItem.fixture("", triggeredBy: ["dairy"])
        #expect(table.with(avoidItems: [dairy, dairy]).issues == [.duplicateAvoidItem("dairy")])
        #expect(table.with(avoidItems: [dairy, blank]).issues == [.blankAvoidItemID(position: 1)])
    }

    @Test func everyAvoidItemHasAnEnglishName() {
        let nameless = dairy.with(name: blankText)
        #expect(table.with(avoidItems: [nameless]).issues == [.missingAvoidItemName("dairy")])
    }

    @Test func anAvoidItemMustBeTriggeredBySomething() {
        let harmless = AvoidItem.fixture("lupin", triggeredBy: [])
        #expect(table.with(avoidItems: [dairy, harmless]).issues == [.avoidItemTriggersNothing("lupin")])
    }

    @Test func anAvoidItemMayOnlyUseDeclaredFacts() {
        let mistyped = AvoidItem.fixture("eggs", triggeredBy: ["eggs"])
        #expect(table.with(avoidItems: [mistyped]).issues == [.undeclaredAvoidItemFact("eggs", "eggs")])
    }

    @Test func aDietIDMayAppearOnlyOnceAndIsNeverBlank() {
        let blank = Diet.fixture("", excludes: ["meat"])
        #expect(table.with(diets: [vegan, vegan]).issues == [.duplicateDiet("vegan")])
        #expect(table.with(diets: [vegan, blank]).issues == [.blankDietID(position: 1)])
    }

    @Test func everyDietHasAnEnglishNameAndSummary() {
        #expect(table.with(diets: [vegan.with(name: blankText)]).issues == [.missingDietText("vegan")])
        #expect(table.with(diets: [vegan.with(summary: blankText)]).issues == [.missingDietText("vegan")])
    }

    @Test func aDietMustRuleSomethingOut() {
        let anything = Diet.fixture("flexitarian", excludes: [])
        #expect(table.with(diets: [vegan, anything]).issues == [.dietExcludesNothing("flexitarian")])
    }

    @Test func aDietMayOnlyUseDeclaredFacts() {
        let mistyped = Diet.fixture("vegetarian", excludes: ["meat", "fsh"])
        #expect(table.with(diets: [mistyped]).issues == [.undeclaredDietFact("vegetarian", "fsh")])
    }
}
