import Testing

@testable import TomiCore

@Suite struct IngredientTableValidationTests {
    let garlic = Ingredient.fixture("garlic")
    let butter = Ingredient.fixture("butter", contains: [.dairy])

    @Test func theFixtureIsValid() {
        #expect(IngredientTable.fixture().issues.isEmpty)
    }

    @Test func aTableListsAtLeastOneIngredient() {
        #expect(IngredientTable.fixture(ingredients: []).issues == [.noIngredients])
    }

    @Test func anIngredientIDMayAppearOnlyOnce() {
        let sameIDOtherFacts = Ingredient.fixture("butter")
        let table = IngredientTable.fixture(ingredients: [garlic, butter, sameIDOtherFacts])
        #expect(table.issues == [.duplicateIngredient("butter")])
    }

    @Test(arguments: ["", "  "])
    func anIngredientIDIsNeverBlank(id: String) {
        let blank = Ingredient.fixture(IngredientID(rawValue: id))
        let table = IngredientTable.fixture(ingredients: [garlic, blank, butter])
        #expect(table.issues == [.blankIngredientID(position: 1)])
    }

    @Test(arguments: [LocalizedText([:]), LocalizedText(["en": " "]), LocalizedText(["fr": "Beurre"])])
    func everyIngredientHasAnEnglishName(name: LocalizedText) {
        let table = IngredientTable.fixture(ingredients: [garlic, butter.with(name: name)])
        #expect(table.issues == [.missingIngredientName("butter")])
    }

    @Test func everyProblemIsReportedAtOnce() {
        let blank = Ingredient.fixture("")
        let nameless = garlic.with(name: LocalizedText([:]))
        let table = IngredientTable.fixture(ingredients: [blank, butter, butter, nameless])
        let expected: [IngredientIssue] = [
            .blankIngredientID(position: 0), .duplicateIngredient("butter"), .missingIngredientName("garlic"),
        ]
        #expect(table.issues == expected)
    }
}
