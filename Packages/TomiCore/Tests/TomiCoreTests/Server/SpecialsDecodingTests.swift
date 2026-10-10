import Foundation
import Testing

@testable import TomiCore

/// Offers as `POST /v1/specials` sends them, and the request that asks for them.
@Suite struct SpecialsDecodingTests {
    @Test func anOfferIsReadWithItsSwapsMissingIngredientsAndCheck() throws {
        let offer = try ServerJSON.decode(Offer.self, from: ServerJSON.offer)
        #expect(offer.lessonID == "garlic-butter")
        #expect(offer.revision == 2)
        #expect(offer.skill == OfferSkill(id: "eggs", name: "Eggs"))
        #expect(offer.level == NamedLevel(number: 1, name: "Soft"))
        #expect(offer.swaps.map(\.applied) == [AppliedSwap(removed: "butter", added: "olive-oil")])
        #expect(offer.missing.map(\.id) == ["garlic"])
        #expect(offer.reason == "Quick tonight.")
        #expect(offer.checked == CheckedRestrictions(diet: "vegan", avoid: ["nuts"]))
    }

    @Test func anOfferWithoutItsCheckIsRefused() {
        let check = #""checked": {"diet": "vegan", "avoid": ["nuts"]}"#
        let unchecked = ServerJSON.offer.replacing(check, with: #""x": 1"#)
        #expect(throws: DecodingError.self) {
            try ServerJSON.decode(Offer.self, from: unchecked)
        }
    }

    @Test func aCheckWithoutADietIsRefusedNotReadAsEatingEverything() {
        #expect(throws: DecodingError.self) {
            try ServerJSON.decode(CheckedRestrictions.self, from: #"{"avoid": []}"#)
        }
    }

    @Test func aResponseWithNoSpecialAndAnUnknownRankingIsRead() throws {
        let text = #"{"libraryVersion": 4, "rankedBy": "oracle", "special": null, "alternatives": []}"#
        let response = try ServerJSON.decode(SpecialsResponse.self, from: text)
        #expect(response.special == nil)
        #expect(response.rankedBy == nil)
        #expect(response.libraryVersion == 4)
    }

    @Test func theRequestSendsSortedIngredientsAndLeavesOutAMissingScan() throws {
        let request = SpecialsRequest(ingredients: ["spinach", "egg"], scanID: nil)
        let text = String(decoding: try JSONEncoder().encode(request), as: UTF8.self)
        #expect(text == #"{"ingredients":["egg","spinach"]}"#)
    }

    @Test func theRequestNamesTheScan() throws {
        let request = SpecialsRequest(ingredients: ["egg"], scanID: "scan-1")
        let encoder = JSONEncoder()
        encoder.outputFormatting = .sortedKeys
        let text = String(decoding: try encoder.encode(request), as: UTF8.self)
        #expect(text == #"{"ingredients":["egg"],"scanId":"scan-1"}"#)
    }
}
