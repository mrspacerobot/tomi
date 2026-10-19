import Testing

@testable import TomiCore

/// After `409 version_conflict` the cook's change is made again on the profile as the server has it now.
@Suite struct ProfilePatchRebasingTests {
    @Test func onlyTheCooksChangesAreMadeAgainOnTheCurrentProfile() throws {
        var after = CookProfile()
        after.setWeeklyGoal(6)
        let patch = ProfilePatch(version: 1, before: CookProfile(), after: after)
        let rebased = try patch.rebased(on: Self.nutsFromElsewhere)
        #expect(rebased.version == 2)
        #expect(rebased.before == Self.nutsFromElsewhere.profile)
        #expect(rebased.after.avoid == ["nuts"])
        #expect(rebased.after.weeklyGoal == 6)
    }

    static var nutsFromElsewhere: ProfileEnvelope {
        var elsewhere = CookProfile()
        elsewhere.avoid = ["nuts"]
        return ProfileEnvelope(version: 2, schemaVersion: 1, profile: elsewhere)
    }

    @Test func aConfirmationIsNotCarriedOver() throws {
        var before = CookProfile()
        before.avoid = ["nuts"]
        var patch = ProfilePatch(version: 1, before: before, after: CookProfile())
        patch.allowsWeakerRestrictions = true
        let rebased = try patch.rebased(on: ProfileEnvelope(version: 3, schemaVersion: 1, profile: before))
        #expect(!rebased.allowsWeakerRestrictions)
        #expect(rebased.after.avoid.isEmpty)
    }
}
