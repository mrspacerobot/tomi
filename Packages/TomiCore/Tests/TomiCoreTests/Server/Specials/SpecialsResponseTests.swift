import Foundation
import Testing

@testable import TomiCore

/// The top of `POST /v1/lessons/suggest`: the graph it used, how it ranked, and offers that cannot be read.
@Suite struct SpecialsResponseTests {
    let good = GraphJSON.offer()
    let unreadable = GraphJSON.offer(checked: #"{"avoid": []}"#)

    @Test func theGraphAndTheRankingAreRead() throws {
        let text = GraphJSON.response(special: good, alternatives: [good])
        let response = try ServerJSON.decode(SpecialsResponse.self, from: text)
        #expect(response.graphVersion == "2026.10.1")
        #expect(response.graphChannel == "draft")
        #expect(response.rankedBy == .model)
        #expect(response.special?.recipeID == "recipe/soft-scrambled-eggs")
        #expect(response.alternatives.count == 1)
    }

    @Test func aResponseWithNoSpecialAndAnUnknownRankingIsRead() throws {
        let text =
            #"{"graphVersion": "1", "graphChannel": "draft", "rankedBy": "oracle", "#
            + #""special": null, "alternatives": []}"#
        let response = try ServerJSON.decode(SpecialsResponse.self, from: text)
        #expect(response.special == nil)
        #expect(response.rankedBy == nil)
    }

    /// An offer that cannot be read is unavailable. It is never shown on trust.
    @Test func anOfferThatCannotBeReadIsLeftOutAndTheRestStay() throws {
        let text = GraphJSON.response(special: unreadable, alternatives: [unreadable, good])
        let response = try ServerJSON.decode(SpecialsResponse.self, from: text)
        #expect(response.special == nil)
        #expect(response.alternatives.count == 1)
    }

    /// Offers that all fail would otherwise read as "nothing tonight", which is not what happened.
    @Test func aResponseWhoseOffersAllFailToReadIsAnError() {
        let text = GraphJSON.response(special: unreadable, alternatives: [unreadable])
        #expect(throws: DecodingError.self) {
            try ServerJSON.decode(SpecialsResponse.self, from: text)
        }
    }

    @Test func theLessonShapedAnswerOfTheOldServerIsNotReadAsAGraphAnswer() {
        let text = #"{"libraryVersion": 4, "rankedBy": "model", "special": null, "alternatives": []}"#
        #expect(throws: DecodingError.self) {
            try ServerJSON.decode(SpecialsResponse.self, from: text)
        }
    }

    @Test func theRequestSendsSortedIngredientsAndLeavesOutAMissingScan() throws {
        let request = SpecialsRequest(ingredients: ["spinach", "egg"], scanID: nil)
        let text = String(bytes: try JSONEncoder().encode(request), encoding: .utf8)!
        #expect(text == #"{"ingredients":["egg","spinach"]}"#)
    }

    @Test func theRequestNamesTheScan() throws {
        let request = SpecialsRequest(ingredients: ["egg"], scanID: "scan-1")
        let encoder = JSONEncoder()
        encoder.outputFormatting = .sortedKeys
        let text = String(bytes: try encoder.encode(request), encoding: .utf8)!
        #expect(text == #"{"ingredients":["egg"],"scanId":"scan-1"}"#)
    }
}
