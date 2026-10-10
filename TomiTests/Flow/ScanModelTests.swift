import Foundation
import Testing
import TomiCore

@testable import Tomi

/// The scan against the fake server: consent first, then the photo, the cook's list and tonight's menu.
@MainActor
@Suite struct ScanModelTests {
    func scan(offersNothing: Bool = false) async throws -> ScanModel {
        let api = FakeTomiAPI(library: BundledLessonLibrary(), offersNothing: offersNothing)
        let profile = ProfileModel(api: api, store: InMemoryProgressStore())
        try await profile.load()
        let model = ScanModel(api: api, profile: profile)
        await model.start()
        return model
    }

    @Test func theFirstScanAsksForConsentWithKeepingThePhotoOff() async throws {
        let model = try await scan()
        #expect(model.stage == .consent)
        #expect(!model.keepsPhoto)
    }

    @Test func aPhotoIsReadOnlyAfterTheCooksYes() async throws {
        let model = try await scan()
        await model.send(jpeg: PhotoSource.fakePhoto)
        #expect(model.stage == .consent)
        await model.agree()
        #expect(model.stage == .ready)
        await model.send(jpeg: PhotoSource.fakePhoto)
        #expect(model.stage == .confirming)
        #expect(!model.list.items.isEmpty)
    }

    @Test func unsureAndUnknownItemsDoNotCountUntilTicked() async throws {
        let model = try await scan()
        await model.agree()
        await model.send(jpeg: PhotoSource.fakePhoto)
        let ticked = model.list.items.filter(\.isTicked)
        #expect(model.list.confirmedIngredients.count == ticked.count)
        #expect(ticked.count < model.list.items.count)
    }

    @Test func tonightsMenuShowsOffersCheckedForTheCook() async throws {
        let model = try await scan()
        model.typeInstead()
        await model.findSpecial()
        guard case .menu(let menu) = model.stage else {
            Issue.record("No menu")
            return
        }
        #expect(menu.special != nil)
    }

    @Test func noDishTonightIsAKindEmptyStateNotAnError() async throws {
        let model = try await scan(offersNothing: true)
        model.typeInstead()
        await model.findSpecial()
        #expect(model.stage == .nothingTonight)
        #expect(model.problem == nil)
    }
}
