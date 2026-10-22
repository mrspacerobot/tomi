import Foundation
import Testing

@testable import TomiCore

/// The top of `POST /v1/lessons/suggest`: the graph it used, how it ranked, and suggestions that cannot be read.
@Suite struct SuggestionsResponseTests {
    let good = GraphJSON.suggestion()
    let unreadable = GraphJSON.suggestion(checked: #"{"avoid": []}"#)

    @Test func theGraphAndTheRankingAreRead() throws {
        let text = GraphJSON.response(special: good, alternatives: [good])
        let response = try ServerJSON.decode(SuggestionsResponse.self, from: text)
        #expect(response.rankedBy == .model)
        #expect(response.special?.recipeID == "recipe/soft-scrambled-eggs")
        #expect(response.alternatives.count == 1)
    }

    @Test func aResponseWithNoSpecialAndAnUnknownRankingIsRead() throws {
        let text =
            #"{"rankedBy": "oracle", "#
            + #""special": null, "alternatives": []}"#
        let response = try ServerJSON.decode(SuggestionsResponse.self, from: text)
        #expect(response.special == nil)
        #expect(response.rankedBy == nil)
    }

    /// A suggestion that cannot be read is unavailable. It is never shown on trust.
    @Test func anSuggestionThatCannotBeReadIsLeftOutAndTheRestStay() throws {
        let text = GraphJSON.response(special: unreadable, alternatives: [unreadable, good])
        let response = try ServerJSON.decode(SuggestionsResponse.self, from: text)
        #expect(response.special == nil)
        #expect(response.alternatives.count == 1)
    }

    /// Suggestions that all fail would otherwise read as "nothing tonight", which is not what happened.
    @Test func aResponseWhoseSuggestionsAllFailToReadIsAnError() {
        let text = GraphJSON.response(special: unreadable, alternatives: [unreadable])
        #expect(throws: DecodingError.self) {
            try ServerJSON.decode(SuggestionsResponse.self, from: text)
        }
    }

    @Test func theRequestSendsSortedIngredientsAndLeavesOutAMissingScan() throws {
        let request = SuggestionsRequest(ingredients: ["spinach", "egg"], scanID: nil)
        let text = String(bytes: try JSONEncoder().encode(request), encoding: .utf8)!
        #expect(text == #"{"ingredients":["egg","spinach"]}"#)
    }

    @Test func theRequestNamesTheScan() throws {
        let request = SuggestionsRequest(ingredients: ["egg"], scanID: "scan-1")
        let encoder = JSONEncoder()
        encoder.outputFormatting = .sortedKeys
        let text = String(bytes: try encoder.encode(request), encoding: .utf8)!
        #expect(text == #"{"ingredients":["egg"],"scanId":"scan-1"}"#)
    }
}
