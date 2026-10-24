import Foundation
import Testing

@testable import TomiCore

/// A suggestion the app cannot read in full is unavailable: nothing unreadable is ever read as "allowed" or "empty".
@Suite struct SuggestionRefusalTests {
    @Test func anSuggestionWithoutItsCheckIsRefused() {
        let unchecked = GraphJSON.suggestion().replacing(#", "checked": "# + GraphJSON.checked, with: "")
        #expect(throws: DecodingError.self) {
            try ServerJSON.decode(Suggestion.self, from: unchecked)
        }
    }

    @Test func aCheckWithoutADietIsRefusedNotReadAsEatingEverything() {
        #expect(throws: DecodingError.self) {
            try ServerJSON.decode(CheckedRestrictions.self, from: #"{"avoid": []}"#)
        }
    }

    /// A plan without its missing list would read as "nothing to buy".
    @Test(arguments: ["ingredients", "substitutions", "omittedParts", "missing", "equipment"])
    func aSafePlanWithoutOneOfItsListsIsRefused(_ key: String) {
        let broken = GraphJSON.plan.replacing(#""\#(key)""#, with: #""x\#(key)""#)
        #expect(throws: DecodingError.self) {
            try ServerJSON.decode(Suggestion.self, from: GraphJSON.suggestion(plan: broken))
        }
    }

    @Test func aRatioThatCannotBeReadRefusesTheSuggestion() {
        let broken = GraphJSON.plan.replacing(#""stand_in": 1"#, with: #""stand_in": "one""#)
        #expect(throws: DecodingError.self) {
            try ServerJSON.decode(Suggestion.self, from: GraphJSON.suggestion(plan: broken))
        }
    }
}
