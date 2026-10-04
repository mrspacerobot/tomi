import Testing

@testable import TomiCore

@Suite struct LessonIngredientValidationTests {
    @Test func anIngredientMissingFromTheTableIsReported() {
        var lesson = Lesson.fixture()
        lesson.ingredients.append(.fixture("dragon-fruit"))
        #expect(lesson.issuesInTheFixtureLibrary() == [.unknownIngredient("dragon-fruit")])
    }

    @Test func anIngredientIsListedOnlyOnce() {
        var lesson = Lesson.fixture()
        lesson.ingredients.append(.fixture("garlic"))
        #expect(lesson.issuesInTheFixtureLibrary() == [.duplicateIngredient("garlic")])
    }

    @Test(arguments: [0, -30, Double.nan, Double.infinity])
    func aMetricAmountIsMoreThanNothing(value: Double) {
        var lesson = Lesson.fixture()
        lesson.ingredients[0].metric = Amount(value, .gram)
        #expect(lesson.issuesInTheFixtureLibrary() == [.amountNotPositive("garlic", .metric)])
    }

    @Test(arguments: [0, -0.5])
    func aCupsAmountIsMoreThanNothing(value: Double) {
        var lesson = Lesson.fixture()
        lesson.ingredients[1].cups = Amount(value, .cup)
        #expect(lesson.issuesInTheFixtureLibrary() == [.amountNotPositive("butter", .cups)])
    }

    @Test func theMetricAmountUsesAMetricUnit() {
        var lesson = Lesson.fixture()
        lesson.ingredients[0].metric = Amount(1, .cup)
        #expect(lesson.issuesInTheFixtureLibrary() == [.unitOutsideSystem("garlic", .metric)])
    }

    @Test(arguments: [AmountUnit.gram, .millilitre])
    func theCupsAmountUsesACupsUnit(unit: AmountUnit) {
        var lesson = Lesson.fixture()
        lesson.ingredients[0].cups = Amount(1, unit)
        #expect(lesson.issuesInTheFixtureLibrary() == [.unitOutsideSystem("garlic", .cups)])
    }

    @Test(arguments: [AmountUnit.piece, .tablespoon, .teaspoon])
    func countsAndSpoonsBelongToBothSystems(unit: AmountUnit) {
        var lesson = Lesson.fixture()
        lesson.ingredients[0] = LessonIngredient(ingredient: "garlic", metric: Amount(2, unit), cups: Amount(2, unit))
        #expect(lesson.issuesInTheFixtureLibrary().isEmpty)
    }

    @Test func theAmountFollowsTheCooksUnits() {
        let butter = LessonIngredient.fixture("butter")
        #expect(butter.amount(in: .metric) == Amount(30, .gram))
        #expect(butter.amount(in: .cups) == Amount(2, .tablespoon))
    }
}
