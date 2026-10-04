import Foundation
import Testing

@testable import TomiCore

/// Saved diet and avoid answers are never weakened, whatever version of the app wrote them or however they broke.
@Suite struct CookPreferencesRestrictionCodingTests {
    @Test func aDietUnknownHereIsKeptSoTheFilterOffersNothing() throws {
        #expect(try decode(#"{"diet": "keto"}"#).diet == "keto")
    }

    @Test func everySavedAvoidItemIsKeptEvenOneTheTableDoesNotKnowYet() throws {
        #expect(try decode(#"{"avoid": ["nuts", "lupin"]}"#).avoid == ["nuts", "lupin"])
    }

    @Test func aMissingOrNullDietMeansTheCookEatsEverything() throws {
        #expect(try decode("{}").diet == nil)
        #expect(try decode(#"{"diet": null}"#).diet == nil)
    }

    @Test func aMissingOrNullAvoidListMeansNothingIsAvoided() throws {
        #expect(try decode("{}").avoid.isEmpty)
        #expect(try decode(#"{"avoid": null}"#).avoid.isEmpty)
    }

    @Test(arguments: [#"{"diet": 3}"#, #"{"diet": ["vegan"]}"#, #"{"diet": {"name": "vegan"}}"#])
    func aDietThatCannotBeReadBecomesUnreadable(json: String) throws {
        #expect(try decode(json).diet == DietID.unreadable)
    }

    @Test(arguments: [#"{"avoid": "nuts"}"#, #"{"avoid": ["nuts", 3]}"#, #"{"avoid": {"nuts": true}}"#])
    func anAvoidListThatCannotBeReadBecomesUnreadable(json: String) throws {
        #expect(try decode(json).avoid == [AvoidItemID.unreadable])
    }

    @Test func anUnreadableAnswerSurvivesBeingSavedAgain() throws {
        let unreadable = try decode(#"{"diet": 3, "avoid": "nuts"}"#)
        let savedAgain = try decode(JSONEncoder().encode(unreadable))
        #expect(savedAgain.diet == DietID.unreadable)
        #expect(savedAgain.avoid == [AvoidItemID.unreadable])
    }

    @Test func theUnreadableIdIsBlank() {
        #expect(DietID.unreadable.rawValue.isEmpty)
        #expect(AvoidItemID.unreadable.rawValue.isEmpty)
    }

    private func decode(_ json: String) throws -> CookPreferences {
        try decode(Data(json.utf8))
    }

    private func decode(_ data: Data) throws -> CookPreferences {
        try JSONDecoder().decode(CookPreferences.self, from: data)
    }
}
