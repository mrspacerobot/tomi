import Foundation
import Testing

@testable import TomiCore

/// `PATCH /v1/profile` sends the version and only what the cook changed.
@Suite struct ProfilePatchTests {
    func text(of patch: ProfilePatch) throws -> String {
        String(decoding: try patch.body(), as: UTF8.self)
    }

    @Test func onlyTheChangedFieldsAreSentWithTheVersion() throws {
        var after = CookProfile()
        after.setWeeklyGoal(5)
        after.avoid = ["sesame", "nuts"]
        let patch = ProfilePatch(version: 3, before: CookProfile(), after: after)
        #expect(try text(of: patch) == #"{"avoid":["nuts","sesame"],"version":3,"weeklyGoal":5}"#)
    }

    @Test func aClearedAnswerIsSentAsNull() throws {
        var before = CookProfile()
        before.units = .cups
        before.diet = "vegan"
        let patch = ProfilePatch(version: 1, before: before, after: CookProfile())
        #expect(try text(of: patch) == #"{"diet":null,"units":null,"version":1}"#)
    }

    @Test func weakerRestrictionsAreAllowedOnlyWhenTheCookConfirmed() throws {
        var before = CookProfile()
        before.avoid = ["nuts"]
        var patch = ProfilePatch(version: 2, before: before, after: CookProfile())
        #expect(try !text(of: patch).contains("allowWeakerRestrictions"))
        patch.allowsWeakerRestrictions = true
        #expect(try text(of: patch) == #"{"allowWeakerRestrictions":true,"avoid":[],"version":2}"#)
    }

    @Test func noChangeSendsOnlyTheVersion() throws {
        let profile = CookProfile.fixtureWithEveryAnswerChanged()
        let patch = ProfilePatch(version: 7, before: profile, after: profile)
        #expect(!patch.hasChanges)
        #expect(try text(of: patch) == #"{"version":7}"#)
    }

    @Test func finishingOnboardingIsSentUnderTheServersName() throws {
        var after = CookProfile()
        after.isOnboardingDone = true
        let patch = ProfilePatch(version: 0, before: CookProfile(), after: after)
        #expect(try text(of: patch) == #"{"onboardingDone":true,"version":0}"#)
    }
}
