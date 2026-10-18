import Testing

@testable import TomiCore

/// How the screens name the lines of a graph recipe and tell what the safe plan does to each.
@Suite struct OfferNamesTests {
    let offer = Offer.sample(checked: CheckedRestrictions(diet: nil, avoid: []))

    func line(_ thing: OptionID) throws -> SourceLine {
        try #require(offer.sourceRecipe.ingredients.first { $0.thing == thing })
    }

    @Test func anIngredientOfThePlanUsesTheServersName() {
        #expect(offer.name(ofSourceIngredient: "ingredient/egg") == "Egg")
    }

    @Test func anIngredientTheServerSwappedOutKeepsItsName() {
        #expect(offer.name(ofSourceIngredient: "ingredient/butter") == "Butter")
    }

    @Test func anIngredientTheServerDidNotNameIsMadeReadable() {
        #expect(offer.name(ofSourceIngredient: "ingredient/olive-oil") == "olive oil")
        #expect(OptionID(rawValue: "plain").readable == "plain")
    }

    @Test func theSafePlanSaysWhichLinesItSwapsAndWhichItLeavesOut() throws {
        #expect(offer.substitution(for: try line("ingredient/butter"))?.added.name == "Oil")
        #expect(offer.substitution(for: try line("ingredient/egg")) == nil)
        #expect(offer.omits(try line("ingredient/cream")))
        #expect(!offer.omits(try line("ingredient/egg")))
    }
}
