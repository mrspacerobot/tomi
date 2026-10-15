import Foundation
import Testing

@testable import TomiCore

/// The cupboard question: until the cook answers, the server's assumed staples are at home.
@Suite struct CookProfileCupboardTests {
    static let assumed: Set<OptionID> = ["salt", "olive-oil"]

    @Test func untilAnsweredTheCupboardIsWhatTheServerAssumes() {
        var profile = CookProfile()
        profile.cupboardStaples = ["cumin"]
        #expect(!profile.cupboardAnswered)
        #expect(profile.cupboard(assumedUntilAnswered: Self.assumed) == Self.assumed)
    }

    @Test func onceAnsweredTheCupboardIsTheSavedStaplesEvenWhenEmpty() {
        var profile = CookProfile()
        profile.cupboardAnswered = true
        #expect(profile.cupboard(assumedUntilAnswered: Self.assumed).isEmpty)
        profile.cupboardStaples = ["cumin"]
        #expect(profile.cupboard(assumedUntilAnswered: Self.assumed) == ["cumin"])
    }

    @Test func theFirstTapAnswersTheQuestionFromTheAssumedStaples() {
        var profile = CookProfile()
        profile.toggleCupboardStaple("salt", assumedUntilAnswered: Self.assumed)
        #expect(profile.cupboardAnswered)
        #expect(profile.cupboardStaples == ["olive-oil"])
        profile.toggleCupboardStaple("salt", assumedUntilAnswered: Self.assumed)
        #expect(profile.cupboardStaples == ["olive-oil", "salt"])
    }

    @Test func leavingTheCupboardAsShownStillAnswersIt() {
        var profile = CookProfile()
        profile.answerCupboard(assumedUntilAnswered: Self.assumed)
        #expect(profile.cupboardAnswered)
        #expect(profile.cupboardStaples == Self.assumed)
    }

    @Test func answeringAgainKeepsWhatTheCookSaved() {
        var profile = CookProfile()
        profile.cupboardAnswered = true
        profile.cupboardStaples = ["cumin"]
        profile.answerCupboard(assumedUntilAnswered: Self.assumed)
        #expect(profile.cupboardStaples == ["cumin"])
    }

    @Test func anExtraIsAddedOnceAndRemoved() {
        var profile = CookProfile()
        profile.addCupboardStaple("cumin", assumedUntilAnswered: Self.assumed)
        profile.addCupboardStaple("cumin", assumedUntilAnswered: Self.assumed)
        #expect(profile.cupboardStaples == ["cumin", "olive-oil", "salt"])
        profile.removeCupboardStaple("cumin", assumedUntilAnswered: Self.assumed)
        #expect(profile.cupboardStaples == Self.assumed)
    }

    @Test func aProfileWithoutTheFieldReadsAsNotAnswered() throws {
        let profile = try CookProfileCodingTests.decode(#"{"diet": null, "avoid": []}"#)
        #expect(!profile.cupboardAnswered)
    }

    @Test func theServersFieldIsRead() throws {
        let profile = try CookProfileCodingTests.decode(#"{"diet": null, "avoid": [], "cupboardAnswered": true}"#)
        #expect(profile.cupboardAnswered)
    }

    @Test func theFieldIsWrittenAndOnlyAChangeIsSent() throws {
        var after = CookProfile()
        after.answerCupboard(assumedUntilAnswered: Self.assumed)
        let patch = ProfilePatch(version: 3, before: CookProfile(), after: after)
        let body = try #require(JSONSerialization.jsonObject(with: patch.body()) as? [String: Any])
        #expect(body["cupboardAnswered"] as? Bool == true)
        #expect(body["cupboardStaples"] as? [String] == ["olive-oil", "salt"])
    }

    @Test func theStoredCopyKeepsTheAnswer() {
        var profile = CookProfile()
        profile.cupboardAnswered = true
        #expect(SavedProfile(profile).cupboardAnswered == true)
        #expect(SavedProfile(profile).profile.cupboardAnswered)
        #expect(!SavedProfile().profile.cupboardAnswered)
    }

    @Test func theOptionsListTheAssumedStaples() throws {
        let options = try ServerJSON.decode(LibraryOptions.self, from: ServerJSON.options)
        #expect(options.assumedStaples == ["salt"])
    }
}
