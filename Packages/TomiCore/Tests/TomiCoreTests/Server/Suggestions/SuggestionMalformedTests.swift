import Foundation
import Testing

@testable import TomiCore

/// Swaps and amounts the app reads from a suggestion.
@Suite struct SuggestionMalformedTests {
    /// Two ingredients swapped for the same stand-in are two substitutions, each with its own identity.
    @Test func twoSwapsForTheSameStandInStayTwoSubstitutions() {
        let oil = NamedOption(id: "ingredient/oil", name: "Oil")
        let butter = SuggestionSwap(removed: NamedOption(id: "ingredient/butter", name: "Butter"), added: oil)
        let cream = SuggestionSwap(removed: NamedOption(id: "ingredient/cream", name: "Cream"), added: oil)
        #expect(Set([butter, cream]).count == 2)
        #expect(butter.id != cream.id)
    }

    @Test func aServingYieldIsAWholeNumberOfServings() {
        #expect(RecipeAmount(value: 2, unit: "serving").wholeServings == 2)
        #expect(RecipeAmount(value: 1.5, unit: "serving").wholeServings == nil)
        #expect(RecipeAmount(value: 2, unit: "gram").wholeServings == nil)
    }
}
