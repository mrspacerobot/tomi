import Foundation
import Testing

@testable import TomiCore

/// Saved preferences must survive older and newer versions of the app reading each other's data.
@Suite struct CookPreferencesCodingTests {
    @Test func changedPreferencesSurviveARoundTrip() throws {
        let preferences = CookPreferences.fixtureWithEveryAnswerChanged()
        #expect(try decode(JSONEncoder().encode(preferences)) == preferences)
    }

    @Test func defaultPreferencesSurviveARoundTrip() throws {
        #expect(try decode(JSONEncoder().encode(CookPreferences())) == CookPreferences())
    }

    @Test func answersAreWrittenAsPlainStringsUnderPermanentNames() throws {
        let saved = try JSONEncoder().encode(CookPreferences.fixtureWithEveryAnswerChanged())
        let json = try #require(String(bytes: saved, encoding: .utf8))
        #expect(json.contains(#""diet":"pescatarian""#))
        #expect(json.contains(#""experience":"comfortable""#))
        #expect(json.contains(#""units":"cups""#))
        #expect(json.contains(#""servings":4"#))
        #expect(json.contains(#""weeklyGoal":5"#))
        #expect(json.contains(#""italian":"love""#))
    }

    @Test func listsAreWrittenUnderPermanentNames() throws {
        let saved = try JSONEncoder().encode(CookPreferences.fixtureWithEveryAnswerChanged())
        let json = try #require(String(bytes: saved, encoding: .utf8))
        #expect(json.contains(#""cuisines":{"#))
        #expect(json.contains(#""avoid":["#))
        #expect(json.contains(#""equipment":["#))
        #expect(json.contains(#""cupboardStaples":["#))
    }

    @Test func missingFieldsFallBackToTheDefaults() throws {
        #expect(try decode("{}") == CookPreferences())
    }

    @Test func aFieldThatIsPresentIsKeptWhileTheRestFallBack() throws {
        var expected = CookPreferences()
        expected.diet = "vegan"
        expected.chosenEquipment = []
        #expect(try decode(#"{"diet": "vegan", "equipment": []}"#) == expected)
    }

    @Test func unknownCuisineAnswersAreDroppedAndTheKnownOnesKept() throws {
        let preferences = try decode(#"{"cuisines": {"italian": "love", "thai": "adore"}}"#)
        #expect(preferences.cuisines.preference(for: "italian") == .love)
        #expect(preferences.cuisines.preference(for: "thai") == .try)
    }

    @Test func everySavedEquipmentIdIsKeptEvenOneTheLibraryDoesNotKnowYet() throws {
        let preferences = try decode(#"{"equipment": ["oven", "air-fryer"]}"#)
        #expect(preferences.chosenEquipment == ["oven", "air-fryer"])
    }

    @Test func anUnknownSingleAnswerFallsBackToItsDefault() throws {
        let preferences = try decode(#"{"experience": "chef", "units": "stones", "servings": 3}"#)
        #expect(preferences.experience == .basics)
        #expect(preferences.chosenUnits == nil)
        #expect(preferences.servings == 3)
    }

    @Test func aFieldOfTheWrongShapeFallsBackToItsDefault() throws {
        let preferences = try decode(#"{"servings": "many", "equipment": "oven", "cuisines": [], "weeklyGoal": 4}"#)
        #expect(preferences.servings == CookPreferences.defaultServings)
        #expect(preferences.chosenEquipment == nil)
        #expect(preferences.cuisines == CuisinePreferences())
        #expect(preferences.weeklyGoal == 4)
    }

    @Test func fieldsFromANewerAppAreIgnored() throws {
        #expect(try decode(#"{"spiceTolerance": "hot", "servings": 3}"#).servings == 3)
    }

    @Test func numbersOutOfRangeAreBroughtBackIntoRange() throws {
        let preferences = try decode(#"{"weeklyGoal": 12, "servings": 0}"#)
        #expect(preferences.weeklyGoal == GameRules.weeklyGoalOptions.upperBound)
        #expect(preferences.servings == CookPreferences.minimumServings)
    }

    private func decode(_ json: String) throws -> CookPreferences {
        try decode(Data(json.utf8))
    }

    private func decode(_ data: Data) throws -> CookPreferences {
        try JSONDecoder().decode(CookPreferences.self, from: data)
    }
}
