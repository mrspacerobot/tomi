import Testing

@testable import TomiCore

/// Which diets allow food, decided by the facts each diet rules out.
@Suite struct IngredientDietTests {
    static let everyDiet: Set<DietID> = ["vegetarian", "vegan", "pescatarian"]
    let table = IngredientTable.fixture()

    @Test func foodWithNoFactsSuitsEveryDiet() {
        #expect(table.diets(allowing: []) == Self.everyDiet)
    }

    @Test(arguments: ["meat", "pork"] as [IngredientFactID])
    func meatSuitsNoDiet(fact: IngredientFactID) {
        #expect(table.diets(allowing: [fact]).isEmpty)
    }

    @Test func fishSuitsOnlyThePescatarian() {
        #expect(table.diets(allowing: ["fish"]) == ["pescatarian"])
    }

    @Test(arguments: ["dairy", "egg"] as [IngredientFactID])
    func dairyAndEggSuitEveryDietButTheVegan(fact: IngredientFactID) {
        #expect(table.diets(allowing: [fact]) == ["vegetarian", "pescatarian"])
    }

    @Test(arguments: ["alcohol", "nuts"] as [IngredientFactID])
    func aFactNoDietRulesOutLeavesEveryDietOpen(fact: IngredientFactID) {
        #expect(table.diets(allowing: [fact]) == Self.everyDiet)
    }

    @Test func theStrictestFactDecides() {
        #expect(table.diets(allowing: ["dairy", "fish"]) == ["pescatarian"])
        #expect(table.diets(allowing: ["dairy", "meat"]).isEmpty)
    }
}
