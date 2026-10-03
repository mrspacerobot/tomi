import Foundation
import Testing

@testable import TomiCore

/// An ingredient read with a fact this build does not know must never look safe, even before validation runs.
@Suite struct IngredientUnknownFactTests {
    @Test func anIngredientWithAnUnknownFactSuitsNoDietAndNoCook() throws {
        let file = Data(#"{"id": "satay", "name": {"en": "Satay"}, "contains": ["peanuts"]}"#.utf8)
        let satay = try JSONDecoder().decode(Ingredient.self, from: file)
        #expect(satay.unknownFacts == ["peanuts"])
        #expect(satay.allowingDiets.isEmpty)
        #expect(!satay.isAllowed(by: CookPreferences()))
    }
}
