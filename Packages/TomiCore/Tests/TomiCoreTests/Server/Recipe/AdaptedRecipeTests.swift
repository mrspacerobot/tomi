import Foundation
import Testing

@testable import TomiCore

/// The recipe the server wrote for this cook, and what it changed from the graph's own.
@Suite struct AdaptedRecipeTests {
    func decoded() throws -> Suggestion {
        try ServerJSON.decode(Suggestion.self, from: GraphJSON.suggestion())
    }

    @Test func theRecipeIsReadWithItsYieldIngredientsAndSteps() throws {
        let recipe = try decoded().recipe
        #expect(recipe.yields == RecipeAmount(value: 2, unit: "serving"))
        #expect(recipe.ingredients.map(\.food.name) == ["Egg", "Oil", "Salt"])
        #expect(recipe.ingredients[1].food.id == "ingredient/oil")
        #expect(recipe.ingredients[1].amount == RecipeAmount(value: 30, unit: "millilitre"))
        #expect(recipe.ingredients[0].forms == [NamedOption(id: "form/beaten", name: "Beaten")])
        #expect(recipe.steps.map(\.number) == [1, 2, 3])
    }

    @Test func aStepKeepsItsTimeTemperatureAndSafetyPoints() throws {
        let steps = try decoded().recipe.steps
        #expect(steps[0].time == nil)
        #expect(steps[0].temperature == nil)
        #expect(steps[0].safetyPoints.isEmpty)
        #expect(steps[1].text == "Stir the eggs in the oil over low heat.")
        #expect(steps[1].time == StepTime(shortest: 4, longest: 6, unit: "minute"))
        #expect(steps[1].temperature == StepTemperature(value: 80, unit: "celsius"))
        #expect(steps[1].safetyPoints == ["raw-or-lightly-cooked-egg"])
        #expect(steps[2].time == StepTime(shortest: 30, longest: 30, unit: "second"))
    }

    @Test func theChangesListEachSwapAndEachLeftOutPart() throws {
        let changes = try decoded().changes
        let swap = try #require(changes.swaps.first)
        #expect(swap.removed.name == "Butter")
        #expect(swap.added.name == "Oil")
        #expect(swap.caveat == "No butter aroma.")
        let left = try #require(changes.leftOut.first)
        #expect(left.part == "enrichment")
        #expect(left.name == "Cream")
        #expect(left.ingredients == [NamedOption(id: "ingredient/cream", name: "Cream")])
    }

    @Test func aNullRatioAndCaveatAreNil() throws {
        let plain = GraphJSON.changes.replacing(GraphJSON.ratio, with: #""ratio": null"#)
            .replacing(GraphJSON.caveat, with: #""caveat": null"#)
        let text = GraphJSON.suggestion(changes: plain)
        let swap = try #require(try ServerJSON.decode(Suggestion.self, from: text).changes.swaps.first)
        #expect(swap.ratio == nil)
        #expect(swap.caveat == nil)
    }

    @Test func anAbsentTimeTemperatureRatioAndCaveatAreNil() throws {
        let bare = GraphJSON.recipe.replacing(#""time": null, "temperature": null, "#, with: "")
        let swap = #"{"removed": {"id": "a", "name": "A"}, "added": {"id": "b", "name": "B"}}"#
        let changes = #"{"swaps": ["# + swap + #"], "leftOut": []}"#
        let text = GraphJSON.suggestion(recipe: bare, changes: changes)
        let suggestion = try ServerJSON.decode(Suggestion.self, from: text)
        #expect(bare != GraphJSON.recipe)
        #expect(suggestion.recipe.steps[0].time == nil)
        #expect(suggestion.recipe.steps[0].temperature == nil)
        #expect(suggestion.changes.swaps.first?.ratio == nil)
        #expect(suggestion.changes.swaps.first?.caveat == nil)
    }

    @Test func emptyChangesAreRead() throws {
        let none = GraphJSON.suggestion(changes: #"{"swaps": [], "leftOut": []}"#)
        let changes = try ServerJSON.decode(Suggestion.self, from: none).changes
        #expect(changes.swaps.isEmpty)
        #expect(changes.leftOut.isEmpty)
    }

    /// A newer server may add fields anywhere; the app reads what it knows.
    @Test func unknownFieldsAreIgnored() throws {
        var recipe = GraphJSON.recipe.replacing(#""yields""#, with: #""futureNote": 1, "yields""#)
        recipe = recipe.replacing(#""number": 1,"#, with: #""number": 1, "future": [1],"#)
        let changes = GraphJSON.changes.replacing(#""leftOut""#, with: #""extra": {}, "leftOut""#)
        let text = GraphJSON.suggestion(recipe: recipe, changes: changes)
        let suggestion = try ServerJSON.decode(Suggestion.self, from: text)
        #expect(suggestion.recipe.steps.count == 3)
        #expect(suggestion.changes.leftOut.count == 1)
    }

    @Test func aTemperatureInAKnownUnitIsMeasuredAndAnotherIsNot() {
        let hot = StepTemperature(value: 80, unit: "celsius")
        #expect(hot.measurement == Measurement(value: 80, unit: UnitTemperature.celsius))
        let old = StepTemperature(value: 350, unit: "fahrenheit")
        #expect(old.measurement == Measurement(value: 350, unit: UnitTemperature.fahrenheit))
        #expect(StepTemperature(value: 5, unit: "gas mark").measurement == nil)
    }
}
