import Foundation
import Testing
import TomiCore

@testable import Tomi

/// The cook's answers, fetched from and saved to the server, and the copy kept on the phone.
@MainActor
@Suite struct ProfileModelTests {
    let store = InMemoryProgressStore()

    func model(starting profile: CookProfile = CookProfile()) async throws -> ProfileModel {
        let api = FakeTomiAPI(library: BundledLessonLibrary(), profile: profile)
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

    /// The cook started a dish, then said they avoid something more: only the server can check the dish again.
    @Test func aChangedRestrictionForgetsTheLessonInProgress() async throws {
        let model = try await model()
        try store.saveActiveLesson(ActiveLesson(lesson: "a-lesson", revision: 1), at: .october(5))
        var answers = model.profile
        answers.toggleAvoid("fake-nuts")
        _ = try await model.save(answers, confirmedWeaker: false)
        #expect(try store.activeLesson() == nil)
    }

    @Test func anOtherAnswerKeepsTheLessonInProgress() async throws {
        let model = try await model()
        try store.saveActiveLesson(ActiveLesson(lesson: "a-lesson", revision: 1), at: .october(5))
        var answers = model.profile
        answers.setWeeklyGoal(6)
        _ = try await model.save(answers, confirmedWeaker: false)
        #expect(try store.activeLesson() != nil)
    }
}
