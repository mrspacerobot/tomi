import Foundation
import Testing

@testable import TomiCore

/// Only an absent field or an explicit null may be nil. A value that is there but wrong makes the offer unreadable.
@Suite struct OfferMalformedTests {
    func offer(replacing old: String, with new: String) -> String {
        GraphJSON.offer().replacing(old, with: new)
    }

    @Test(arguments: [
        (#""amount": {"unit": "piece", "value": 5}"#, #""amount": {"unit": "piece", "value": "five"}"#),
        (#""amount": {"unit": "piece", "value": 5}"#, #""amount": 5"#),
        (#"{"from": 4, "to": 6, "unit": "minute"}"#, #"{"from": "four", "to": 6, "unit": "minute"}"#),
        (#"{"from": 4, "to": 6, "unit": "minute"}"#, #""soon""#),
        (#""yields": {"unit": "serving", "value": 2}"#, #""yields": "two""#),
        (#""yields": {"unit": "serving", "value": 2}"#, #""yields": {"unit": "serving"}"#),
    ])
    func aPresentButMalformedFieldDropsTheOffer(_ pair: (String, String)) {
        let broken = offer(replacing: pair.0, with: pair.1)
        #expect(throws: DecodingError.self) {
            try ServerJSON.decode(Offer.self, from: broken)
        }
    }

    @Test func anExplicitNullIsRead() throws {
        var text = offer(replacing: #""amount": {"unit": "piece", "value": 5}"#, with: #""amount": null"#)
        text = text.replacing(#""yields": {"unit": "serving", "value": 2}"#, with: #""yields": null"#)
        let source = try ServerJSON.decode(Offer.self, from: text).sourceRecipe
        #expect(source.ingredients.first?.amount == nil)
        #expect(source.yields == nil)
    }

    @Test func anAbsentFieldIsRead() throws {
        let text = offer(replacing: #""yields": {"unit": "serving", "value": 2}, "#, with: "")
        #expect(try ServerJSON.decode(Offer.self, from: text).sourceRecipe.yields == nil)
    }

    /// Two ingredients swapped for the same stand-in are two substitutions, each with its own identity.
    @Test func twoSwapsForTheSameStandInStayTwoSubstitutions() {
        let oil = NamedOption(id: "ingredient/oil", name: "Oil")
        let butter = OfferSwap(removed: NamedOption(id: "ingredient/butter", name: "Butter"), added: oil)
        let cream = OfferSwap(removed: NamedOption(id: "ingredient/cream", name: "Cream"), added: oil)
        #expect(Set([butter, cream]).count == 2)
        #expect(butter.id != cream.id)
    }

    @Test func aServingYieldIsAWholeNumberOfServings() {
        #expect(SourceAmount(value: 2, unit: "serving").wholeServings == 2)
        #expect(SourceAmount(value: 1.5, unit: "serving").wholeServings == nil)
        #expect(SourceAmount(value: 2, unit: "gram").wholeServings == nil)
    }
}
