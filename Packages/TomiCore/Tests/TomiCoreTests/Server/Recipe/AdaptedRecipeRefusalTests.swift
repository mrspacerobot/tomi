import Foundation
import Testing

@testable import TomiCore

/// A recipe or changes list the app cannot read in full drops the suggestion: nothing unreadable is shown with gaps.
@Suite struct AdaptedRecipeRefusalTests {
    /// A list that is missing must never read as an empty one, or a dish with no steps would look finished.
    @Test(arguments: [
        "yields", "ingredients", "steps", "forms", "safetyPoints", "number", "text", "part", "amount", "name",
    ])
    func aRecipeWithoutAFieldIsRefused(_ key: String) {
        let broken = GraphJSON.recipe.replacing(#""\#(key)""#, with: #""x\#(key)""#)
        #expect(throws: DecodingError.self) {
            try ServerJSON.decode(Suggestion.self, from: GraphJSON.suggestion(recipe: broken))
        }
    }

    @Test(arguments: ["swaps", "leftOut", "removed", "added", "ingredients", "name", "part"])
    func changesWithoutAFieldAreRefused(_ key: String) {
        let broken = GraphJSON.changes.replacing(#""\#(key)""#, with: #""x\#(key)""#)
        #expect(throws: DecodingError.self) {
            try ServerJSON.decode(Suggestion.self, from: GraphJSON.suggestion(changes: broken))
        }
    }

    @Test(arguments: ["recipe", "changes"])
    func aSuggestionWithoutARecipeOrChangesIsRefused(_ key: String) {
        let broken = GraphJSON.suggestion().replacing(#""\#(key)": {"#, with: #""x\#(key)": {"#)
        #expect(broken != GraphJSON.suggestion())
        #expect(throws: DecodingError.self) {
            try ServerJSON.decode(Suggestion.self, from: broken)
        }
    }

    @Test func aSuggestionWithANullRecipeOrNullChangesIsRefused() {
        #expect(throws: DecodingError.self) {
            try ServerJSON.decode(Suggestion.self, from: GraphJSON.suggestion(recipe: "null"))
        }
        #expect(throws: DecodingError.self) {
            try ServerJSON.decode(Suggestion.self, from: GraphJSON.suggestion(changes: "null"))
        }
    }

    @Test(arguments: [
        (#""amount": {"unit": "piece", "value": 5}"#, #""amount": {"unit": "piece", "value": "five"}"#),
        (#""amount": {"unit": "piece", "value": 5}"#, #""amount": null"#),
        (#"{"from": 4, "to": 6, "unit": "minute"}"#, #"{"from": "four", "to": 6, "unit": "minute"}"#),
        (#"{"from": 4, "to": 6, "unit": "minute"}"#, #""soon""#),
        (#"{"value": 80, "unit": "celsius"}"#, #"{"value": "hot", "unit": "celsius"}"#),
        (#"{"value": 80, "unit": "celsius"}"#, #"{"value": 80}"#),
        (#""safetyPoints": ["raw-or-lightly-cooked-egg"]"#, #""safetyPoints": "doneness""#),
        (#""safetyPoints": ["raw-or-lightly-cooked-egg"]"#, #""safetyPoints": [1]"#),
        (#""number": 2"#, #""number": "two""#),
        (#""yields": {"unit": "serving", "value": 2}, "ingredients""#, #""yields": "two", "ingredients""#),
        (#""forms": [{"id": "form/beaten", "name": "Beaten"}]"#, #""forms": [{"id": "form/beaten"}]"#),
    ])
    func aPresentButMalformedValueDropsTheSuggestion(_ pair: (String, String)) {
        let broken = GraphJSON.recipe.replacing(pair.0, with: pair.1)
        #expect(broken != GraphJSON.recipe)
        #expect(throws: DecodingError.self) {
            try ServerJSON.decode(Suggestion.self, from: GraphJSON.suggestion(recipe: broken))
        }
    }

    @Test(arguments: [
        (#""stand_in": 1"#, #""stand_in": "one""#),
        (#""caveat": "No butter aroma.""#, #""caveat": 3"#),
        (#""name": "Cream", "ingredients""#, #""name": 4, "ingredients""#),
    ])
    func aMalformedChangeDropsTheSuggestion(_ pair: (String, String)) {
        let broken = GraphJSON.changes.replacing(pair.0, with: pair.1)
        #expect(broken != GraphJSON.changes)
        #expect(throws: DecodingError.self) {
            try ServerJSON.decode(Suggestion.self, from: GraphJSON.suggestion(changes: broken))
        }
    }

    /// One bad suggestion leaves out only itself; the others of the answer are still read.
    @Test func aSuggestionWithoutARecipeIsLeftOutOfTheAnswer() throws {
        let broken = GraphJSON.suggestion().replacing(#""recipe": {"#, with: #""xrecipe": {"#)
        let answer = GraphJSON.response(special: broken, alternatives: [GraphJSON.suggestion()])
        let response = try ServerJSON.decode(SuggestionsResponse.self, from: answer)
        #expect(response.special == nil)
        #expect(response.alternatives.count == 1)
    }
}
