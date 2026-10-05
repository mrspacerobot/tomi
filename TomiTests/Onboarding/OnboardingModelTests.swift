import Foundation
import Testing
import TomiCore

@testable import Tomi

/// Where the cook is in onboarding, and what is saved as the cook moves between questions.
@MainActor @Suite struct OnboardingModelTests {
    private let store = InMemoryProgressStore()

    @Test func aNewCookStartsOnTheWelcomeWithNoProgress() throws {
        let model = try makeModel()

        #expect(model.step == .welcome)
        #expect(model.progressCompleted == 0)
        #expect(model.dietChoice == nil)
        #expect(!model.canContinue)
    }

    @Test func startingMovesToTheDietQuestion() throws {
        let model = try makeModel()

        model.start()

        #expect(model.step == .diet)
        #expect(model.progressCompleted == 1)
    }

    @Test func choosingADietSavesItAndMovesToWhatToAvoid() throws {
        let model = try makeModel()
        model.start()

        model.choose(.diet("vegetarian"))

        #expect(model.step == .avoid)
        #expect(model.progressCompleted == 2)
        #expect(try store.profile().preferences.diet == "vegetarian")
    }

    /// Eating everything is an answer: it saves no diet but still moves on, and shows as chosen.

    @Test func choosingEverythingSavesNoDietAndMovesOn() throws {
        let model = try makeModel()
        model.start()

        model.choose(.everything)

        #expect(model.step == .avoid)
        #expect(model.dietChoice == .everything)
        #expect(try store.profile().preferences.diet == nil)
    }

    @Test func backKeepsTheEarlierAnswers() throws {
        let model = try makeModel()
        model.start()
        model.choose(.diet("vegan"))
        model.tapAvoid("soy")

        model.back()

        #expect(model.step == .diet)
        #expect(model.dietChoice == .diet("vegan"))
        #expect(model.avoidAnswer.isTicked("soy"))
    }

    @Test func backFromTheWelcomeStaysThere() throws {
        let model = try makeModel()

        model.back()

        #expect(model.step == .welcome)
    }

    @Test func savedAnswersAreShownWhenOnboardingIsOpenedAgain() throws {
        var profile = CookProfile()
        profile.preferences.diet = "vegetarian"
        profile.preferences.avoid = ["nuts"]
        try store.saveProfile(profile, at: .october(5))

        let model = try makeModel()

        #expect(model.dietChoice == .diet("vegetarian"))
        #expect(model.avoidAnswer.isTicked("nuts"))
    }

    /// Saving an answer must keep what the cook set elsewhere in the profile.

    @Test func savingAnAnswerKeepsTheRestOfTheProfile() throws {
        var profile = CookProfile()
        profile.preferences.experience = .comfortable
        try store.saveProfile(profile, at: .october(5))
        let model = try makeModel()
        model.start()

        model.choose(.diet("vegan"))

        #expect(try store.profile().preferences.experience == .comfortable)
    }

    @Test func aStoreThatCannotBeReadGivesNoModel() {
        #expect(throws: ProgressStoreError.unavailable) {
            try OnboardingModel(store: UnavailableProgressStore(), now: { .october(5) })
        }
    }

    private func makeModel() throws -> OnboardingModel {
        try OnboardingModel(store: store, now: { .october(5) })
    }
}
