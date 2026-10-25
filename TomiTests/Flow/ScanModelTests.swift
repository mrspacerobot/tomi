import Foundation
import Testing
import TomiCore

@testable import Tomi

/// The scan against the fake server: the photo, the cook's list and tonight's menu. There is no consent step yet.
@MainActor
@Suite struct ScanModelTests {
    func scan(suggestionsNothing: Bool = false) async throws -> ScanModel {
        let api = FakeTomiAPI(
            library: BundledLessonLibrary(),
            configuration: FakeTomiAPIConfiguration(suggestionsNothing: suggestionsNothing)
        )
        let profile = ProfileModel(api: api, store: InMemoryProgressStore())
        try await profile.load()
        return ScanModel(api: api, profile: profile)
    }

    @Test func theScanStartsAtThePhotoWithNothingToAnswerFirst() async throws {
        let model = try await scan()
        #expect(model.stage == .ready)
    }

    @Test func aPhotoIsReadWithoutAnyConsentStep() async throws {
        let model = try await scan()
        await model.send(jpeg: PhotoSource.fakePhoto)
        #expect(model.stage == .confirming)
        #expect(!model.list.items.isEmpty)
    }

    @Test func unsureAndUnknownItemsDoNotCountUntilTicked() async throws {
        let model = try await scan()
        await model.send(jpeg: PhotoSource.fakePhoto)
        let ticked = model.list.items.filter(\.isTicked)
        #expect(model.list.confirmedIngredients.count == ticked.count)
        #expect(ticked.count < model.list.items.count)
    }

    @Test func tonightsMenuShowsSuggestionsCheckedForTheCook() async throws {
        let model = try await scan()
        model.typeInstead()
        await model.findSuggestions()
        guard case .menu(let menu) = model.stage else {
            Issue.record("No menu")
            return
        }
        #expect(menu.special != nil)
    }

    @Test func noDishTonightIsAKindEmptyStateNotAnError() async throws {
        let model = try await scan(suggestionsNothing: true)
        model.typeInstead()
        await model.findSuggestions()
        #expect(model.stage == .nothingTonight)
        #expect(model.problem == nil)
    }
}
