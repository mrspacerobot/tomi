import Testing

@testable import TomiCore

/// Which diets allow an ingredient, decided fact by fact.
@Suite struct IngredientDietTests {
    @Test func aPlainPlantIngredientSuitsEveryDiet() {
        #expect(Ingredient.fixture("garlic").allowingDiets == Set(Diet.allCases))
    }

    @Test(arguments: [IngredientFact.meat, .pork, .slaughterProduct])
    func meatAndSlaughterProductsSuitOnlyTheCookWhoEatsEverything(fact: IngredientFact) {
        #expect(Ingredient.fixture("food", contains: [fact]).allowingDiets == [.everything])
    }

    @Test(arguments: [IngredientFact.fish, .shellfish])
    func fishAndShellfishSuitThePescatarianToo(fact: IngredientFact) {
        #expect(Ingredient.fixture("food", contains: [fact]).allowingDiets == [.everything, .pescatarian])
    }

    @Test(arguments: [IngredientFact.dairy, .egg, .animalProduct])
    func dairyEggAndHoneySuitEveryoneButTheVegan(fact: IngredientFact) {
        let diets = Ingredient.fixture("food", contains: [fact]).allowingDiets
        #expect(diets == [.everything, .vegetarian, .pescatarian])
    }

    @Test(arguments: [IngredientFact.alcohol, .nuts, .gluten, .soy, .sesame])
    func factsThatAreNotAboutAnimalsLeaveEveryDietOpen(fact: IngredientFact) {
        #expect(Ingredient.fixture("food", contains: [fact]).allowingDiets == Set(Diet.allCases))
    }

    @Test(arguments: IngredientFact.allCases)
    func theCookWhoEatsEverythingIsNeverRefusedByDiet(fact: IngredientFact) {
        #expect(Ingredient.fixture("food", contains: [fact]).allowingDiets.contains(.everything))
    }

    @Test func theStrictestFactDecides() {
        let fishPie = Ingredient.fixture("fish-pie", contains: [.dairy, .fish])
        let rennetCheese = Ingredient.fixture("rennet-cheese", contains: [.dairy, .slaughterProduct])
        let surfAndTurf = Ingredient.fixture("surf-and-turf", contains: [.shellfish, .meat])
        #expect(fishPie.allowingDiets == [.everything, .pescatarian])
        #expect(rennetCheese.allowingDiets == [.everything])
        #expect(surfAndTurf.allowingDiets == [.everything])
    }

    @Test func porkIsMeatWithoutSayingSo() {
        #expect(Ingredient.fixture("bacon", contains: [.pork]).isMeat)
        #expect(Ingredient.fixture("chicken", contains: [.meat]).isMeat)
        #expect(!Ingredient.fixture("butter", contains: [.dairy]).isMeat)
    }
}
