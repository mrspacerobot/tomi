import Testing

@testable import TomiCore

/// Which avoid-list items an ingredient triggers. They are derived from its facts, never written beside them.
@Suite struct IngredientAvoidTests {
    static let factsWithTheirAvoidItem: [(IngredientFact, AvoidItem)] = [
        (.dairy, .dairy), (.egg, .eggs), (.fish, .fish), (.shellfish, .shellfish), (.pork, .pork),
        (.alcohol, .alcohol), (.nuts, .nuts), (.gluten, .gluten), (.soy, .soy), (.sesame, .sesame),
    ]

    @Test(arguments: factsWithTheirAvoidItem)
    func aFactTriggersItsAvoidItem(fact: IngredientFact, item: AvoidItem) {
        #expect(Ingredient.fixture("food", contains: [fact]).avoidItems == [item])
    }

    @Test(arguments: [IngredientFact.meat, .animalProduct, .slaughterProduct])
    func aFactThatOnlyDecidesDietsTriggersNothing(fact: IngredientFact) {
        #expect(Ingredient.fixture("food", contains: [fact]).avoidItems.isEmpty)
    }

    @Test func everyAvoidItemCanBeTriggeredByAFact() {
        let reachable = Set(IngredientFact.allCases.compactMap(\.avoidItem))
        #expect(reachable == Set(AvoidItem.allCases))
    }

    @Test func aPlainPlantIngredientTriggersNothing() {
        #expect(Ingredient.fixture("garlic").avoidItems.isEmpty)
    }

    @Test func anIngredientTriggersEveryItemItContains() {
        let soySauce = Ingredient.fixture("soy-sauce", contains: [.soy, .gluten])
        #expect(soySauce.avoidItems == [.soy, .gluten])
    }
}
