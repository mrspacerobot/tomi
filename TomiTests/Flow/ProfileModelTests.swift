import Foundation
import Testing
import TomiCore

@testable import Tomi

/// The cook's answers, fetched from and saved to the server, and the copy kept on the phone.
@MainActor
@Suite struct ProfileModelTests {
    let store = InMemoryProgressStore()

    func model(starting profile: CookProfile = CookProfile()) async throws -> ProfileModel {
        let api = FakeTomiAPI(profile: profile)
        let model = ProfileModel(api: api, store: store)
        try await model.load()
        return model
    }

    @Test func loadingFetchesTheListsAndKeepsACopyOfTheProfile() async throws {
        var vegan = CookProfile()
        vegan.diet = "fake-vegan"
        let model = try await model(starting: vegan)
        #expect(model.options?.diets.isEmpty == false)
        #expect(model.profile.diet == "fake-vegan")
        #expect(try store.profile().diet == "fake-vegan")
    }

    @Test func anAddedRestrictionIsSavedAtOnce() async throws {
        let model = try await model()
        var answers = model.profile
        answers.toggleAvoid("fake-nuts")
        #expect(try await model.save(answers, confirmedWeaker: false) == .saved)
        #expect(model.profile.avoid == ["fake-nuts"])
        #expect(model.envelope?.version == 1)
    }

    @Test func aRemovedRestrictionWaitsForTheCooksYes() async throws {
        var nuts = CookProfile()
        nuts.avoid = ["fake-nuts"]
        let model = try await model(starting: nuts)
        #expect(try await model.save(CookProfile(), confirmedWeaker: false) == .needsConfirmation)
        #expect(model.profile.avoid == ["fake-nuts"])
        #expect(try await model.save(CookProfile(), confirmedWeaker: true) == .saved)
        #expect(model.profile.avoid.isEmpty)
    }
}
