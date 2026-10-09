import Foundation
import Testing

@testable import TomiCore

/// The profile in the server's JSON. The diet and avoid list must be readable; the rest falls back to defaults.
@Suite struct CookProfileCodingTests {
    static let full =
        #"{"diet": "vegetarian", "avoid": ["nuts"], "cuisinesLoved": ["thai"], "cuisinesToTry": [], "#
        + #""cuisinesNever": ["british"], "cupboardStaples": ["salt"], "equipment": null, "#
        + #""experience": "comfortable", "servings": 4, "units": "cups", "weeklyGoal": 5, "#
        + #""focusSkill": "roux", "onboardingDone": true}"#

    static func decode(_ text: String) throws -> CookProfile {
        try JSONDecoder().decode(CookProfile.self, from: Data(text.utf8))
    }

    @Test func everyFieldIsRead() throws {
        let profile = try Self.decode(Self.full)
        #expect(profile.diet == "vegetarian")
        #expect(profile.avoid == ["nuts"])
        #expect(profile.cuisinesLoved == ["thai"])
        #expect(profile.cuisinesNever == ["british"])
        #expect(profile.cupboardStaples == ["salt"])
        #expect(profile.equipment == nil)
        #expect(profile.experience == .comfortable)
        #expect(profile.servings == 4)
        #expect(profile.units == .cups)
        #expect(profile.weeklyGoal == 5)
        #expect(profile.focusSkill == "roux")
        #expect(profile.isOnboardingDone)
    }

    @Test func aNullDietIsACookWhoEatsEverything() throws {
        let profile = try Self.decode(#"{"diet": null, "avoid": []}"#)
        #expect(profile.diet == nil)
        #expect(profile == CookProfile())
    }

    static let unreadableRestrictions = [
        #"{"avoid": []}"#, #"{"diet": null}"#, #"{"diet": 3, "avoid": []}"#, #"{"diet": null, "avoid": "nuts"}"#,
    ]

    @Test(arguments: unreadableRestrictions)
    func aDietOrAvoidListThatCannotBeReadRefusesTheProfile(text: String) {
        #expect(throws: DecodingError.self) {
            try Self.decode(text)
        }
    }

    @Test func valuesOnlyANewerServerKnowsKeepTheirDefaults() throws {
        let text =
            #"{"diet": null, "avoid": [], "experience": "professional", "units": "imperial", "servings": "two"}"#
        let profile = try Self.decode(text)
        #expect(profile.experience == .basics)
        #expect(profile.units == nil)
        #expect(profile.servings == CookProfile.defaultServings)
    }

    @Test func aProfileSurvivesARoundTripThroughJSON() throws {
        let profile = CookProfile.fixtureWithEveryAnswerChanged()
        let decoded = try JSONDecoder().decode(CookProfile.self, from: JSONEncoder().encode(profile))
        #expect(decoded == profile)
    }

    @Test func unsetAnswersAreWrittenAsNull() throws {
        let data = try JSONEncoder().encode(CookProfile())
        let text = String(decoding: data, as: UTF8.self)
        #expect(text.contains(#""diet":null"#))
        #expect(text.contains(#""equipment":null"#))
        #expect(text.contains(#""units":null"#))
    }
}
