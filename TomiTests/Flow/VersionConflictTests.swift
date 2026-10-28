import Foundation
import Testing
import TomiCore

@testable import Tomi

/// Another device changed the profile in the meantime: the cook's change is made again on the newer profile.
@MainActor
@Suite struct VersionConflictTests {
    @Test func theChangeIsMadeAgainOnTheServersNewerProfile() async throws {
        let api = FakeTomiAPI()
        let phone = ProfileModel(api: api, store: InMemoryProgressStore())
        try await phone.load()
        try await avoidNutsOnAnotherDevice(api)
        var phoneAnswers = phone.profile
        phoneAnswers.setWeeklyGoal(6)
        #expect(try await phone.save(phoneAnswers, confirmedWeaker: false) == .saved)
        #expect(phone.profile.avoid == ["fake-nuts"])
        #expect(phone.profile.weeklyGoal == 6)
        #expect(phone.envelope?.version == 2)
    }

    private func avoidNutsOnAnotherDevice(_ api: FakeTomiAPI) async throws {
        let tablet = ProfileModel(api: api, store: InMemoryProgressStore())
        try await tablet.load()
        var answers = tablet.profile
        answers.toggleAvoid("fake-nuts")
        _ = try await tablet.save(answers, confirmedWeaker: false)
    }
}
