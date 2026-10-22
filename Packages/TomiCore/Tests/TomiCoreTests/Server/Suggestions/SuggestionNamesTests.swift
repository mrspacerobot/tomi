import Testing

@testable import TomiCore

/// How the screens name the lines of a graph recipe and tell what the safe plan does to each.
@Suite struct SuggestionNamesTests {
    let suggestion = Suggestion.sample(checked: CheckedRestrictions(diet: nil, avoid: []))

    func line(_ thing: OptionID) throws -> RecipeIngredient {
        try #require(suggestion.originalRecipe.ingredients.first { $0.thing == thing })
    }

    @Test func anIngredientOfThePlanUsesTheServersName() {
        #expect(suggestion.name(ofSourceIngredient: "ingredient/egg") == "Egg")
    }

    @Test func anIngredientTheServerSwappedOutKeepsItsName() {
        #expect(suggestion.name(ofSourceIngredient: "ingredient/butter") == "Butter")
    }

    @Test func anIngredientTheServerDidNotNameIsMadeReadable() {
        #expect(suggestion.name(ofSourceIngredient: "ingredient/olive-oil") == "olive oil")
        #expect(OptionID(rawValue: "plain").readable == "plain")
    }

    @Test func theSafePlanSaysWhichLinesItSwapsAndWhichItLeavesOut() throws {
        #expect(suggestion.substitution(for: try line("ingredient/butter"))?.added.name == "Oil")
        #expect(suggestion.substitution(for: try line("ingredient/egg")) == nil)
        #expect(suggestion.omits(try line("ingredient/cream")))
        #expect(!suggestion.omits(try line("ingredient/egg")))
    }
}
