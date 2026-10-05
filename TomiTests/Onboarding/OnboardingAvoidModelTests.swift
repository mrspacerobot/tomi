import Foundation
import Testing
import TomiCore

@testable import Tomi

/// The avoid question of onboarding: when Continue is on, what it saves, and when saving fails.
@MainActor @Suite struct OnboardingAvoidModelTests {
    private let store = InMemoryProgressStore()

    @Test func continueIsOffUntilSomethingIsTickedOrNoneIsChosen() throws {
        let model = try makeModel()
        #expect(!model.canContinue)

        model.tapAvoid("nuts")
        #expect(model.canContinue)

        model.tapAvoid("nuts")
        #expect(!model.canContinue)

        model.tapNone()
        #expect(model.canContinue)
    }

    @Test func continuingSavesWhatTheCookAvoids() throws {
        let model = try makeModel()
        model.tapAvoid("nuts")
        model.tapAvoid("shellfish")

        model.continueFromAvoid()

        #expect(try store.profile().preferences.avoid == ["nuts", "shellfish"])
    }

    @Test func continuingWithNoneOfTheseSavesNothingToAvoid() throws {
        let model = try makeModel()
        model.tapAvoid("nuts")
        model.continueFromAvoid()

        model.tapNone()
        model.continueFromAvoid()

        #expect(try store.profile().preferences.avoid.isEmpty)
    }

    @Test func continuingWithoutAnAnswerSavesNothing() throws {
        let model = try makeModel()

        model.continueFromAvoid()

        #expect(try store.profile().preferences.avoid.isEmpty)
        #expect(!model.couldNotSave)
    }

    @Test func anAnswerThatCannotBeSavedDoesNotMoveOnAndSaysSo() throws {
        let model = try OnboardingModel(store: UnsavableProgressStore(), now: { .october(5) })
        model.start()

        model.choose(.diet("vegan"))

        #expect(model.step == .diet)
        #expect(model.couldNotSave)
    }

    @Test func theNamesOfTheTickedItemsFollowTheTableOrder() throws {
        let model = try makeModel()
        let table = try #require(BundledLibrary.ingredientTable())

        model.tapAvoid("shellfish")
        model.tapAvoid("nuts")

        #expect(model.avoidedNames(in: table) == ["Nuts", "Shellfish"])
    }

    private func makeModel() throws -> OnboardingModel {
        try OnboardingModel(store: store, now: { .october(5) })
    }
}
