import Testing

@testable import TomiCore

/// The compound cases of the shipped table: ingredients whose facts are easy to get wrong.
@Suite struct ShippedIngredientFactsTests {
    static let everyDiet: Set<DietID> = ["vegetarian", "vegan", "pescatarian"]
    static let allButVegan: Set<DietID> = ["vegetarian", "pescatarian"]

    @Test func soySauceIsSoyAndGluten() throws {
        let table = try ShippedIngredientTable.load()
        #expect(try table.avoidItems(for: "soy-sauce") == ["soy", "gluten"])
        #expect(try table.diets(allowing: "soy-sauce") == Self.everyDiet)
    }

    @Test func butterIsDairy() throws {
        let table = try ShippedIngredientTable.load()
        #expect(try table.avoidItems(for: "butter") == ["dairy"])
        #expect(try table.diets(allowing: "butter") == Self.allButVegan)
    }

    @Test func parmesanIsDairyAndNotVegetarian() throws {
        let table = try ShippedIngredientTable.load()
        #expect(try table.avoidItems(for: "parmesan") == ["dairy"])
        #expect(try table.diets(allowing: "parmesan").isEmpty)
    }

    @Test func theVegetarianHardCheeseIsDairyAndVegetarian() throws {
        let table = try ShippedIngredientTable.load()
        #expect(try table.avoidItems(for: "vegetarian-hard-cheese") == ["dairy"])
        #expect(try table.diets(allowing: "vegetarian-hard-cheese") == Self.allButVegan)
    }

    @Test(arguments: ["stock", "chicken-stock"] as [IngredientID])
    func stockIsNotVegetarianUnlessItSaysVegetable(stock: IngredientID) throws {
        let table = try ShippedIngredientTable.load()
        #expect(try table.diets(allowing: stock).isEmpty)
        #expect(try table.ingredient(stock).facts.contains("meat"))
    }

    @Test func vegetableStockSuitsEveryDiet() throws {
        let table = try ShippedIngredientTable.load()
        #expect(try table.diets(allowing: "vegetable-stock") == Self.everyDiet)
    }

    @Test func whiteWineIsAlcohol() throws {
        let table = try ShippedIngredientTable.load()
        #expect(try table.avoidItems(for: "white-wine").contains("alcohol"))
    }

    @Test func chickenIsMeatAndEggsAreEggs() throws {
        let table = try ShippedIngredientTable.load()
        #expect(try table.diets(allowing: "chicken-thigh").isEmpty)
        #expect(try table.avoidItems(for: "egg") == ["eggs"])
        #expect(try table.diets(allowing: "egg") == Self.allButVegan)
    }

    @Test func flourAndPastaAreGluten() throws {
        let table = try ShippedIngredientTable.load()
        #expect(try table.avoidItems(for: "flour") == ["gluten"])
        #expect(try table.avoidItems(for: "pasta").contains("gluten"))
    }

    @Test(arguments: ["garlic", "lemon", "spinach", "onion", "rice", "salt", "olive-oil"] as [IngredientID])
    func aPlainPlantIngredientSuitsEveryoneAndTriggersNothing(plant: IngredientID) throws {
        let table = try ShippedIngredientTable.load()
        #expect(try table.diets(allowing: plant) == Self.everyDiet)
        #expect(try table.avoidItems(for: plant).isEmpty)
    }

    @Test func theOmeletteIsVegetarianOnlyWithTheVegetarianCheese() throws {
        let table = try ShippedIngredientTable.load()
        let vegetarian = CookPreferences.fixture(diet: "vegetarian")
        let base: [IngredientID] = ["egg", "spinach", "butter", "salt", "black-pepper"]
        for ingredient in base + ["vegetarian-hard-cheese"] {
            #expect(try table.isAllowed(ingredient, by: vegetarian))
        }
        #expect(try !table.isAllowed("parmesan", by: vegetarian))
    }
}
