import Foundation
import Testing
import TomiCore

@testable import Tomi

/// What the lesson player writes to the outbox when a cook ends.
@MainActor
@Suite struct PlayerSavingTests {
    let store = InMemoryProgressStore()

    /// The server judges each past week by the zone every cook was made in, so the zone is kept with the cook.
    @Test func aCookIsSavedWithTheZoneItWasCookedIn() throws {
        let tokyo = try #require(TimeZone(identifier: "Asia/Tokyo"))
        let model = try player()
        model.cookingZone = tokyo
        model.stop()
        let saved = try store.cookLog()
        #expect(saved.count == 1)
        #expect(saved.first?.session.timeZone == tokyo)
    }

    /// The server takes only graph recipes. The player cooks a bundled lesson, so its cook is kept on the phone and
    /// is never sent, nor counted as waiting to be.
    @Test(.timeLimit(.minutes(1))) func aCookOfABundledLessonIsKeptAndNeverSent() async throws {
        let model = try player()
        model.finish()
        await model.uploader.waitUntilIdle()
        #expect(try store.cookLog().count == 1)
        #expect(try store.pendingCookEntries(for: CookEntry.fixtureAccount).isEmpty)
        #expect(try store.progressSnapshot() == nil)
    }

    /// The cook is saved under the account that cooked it, so no other account who signs in on this phone sends it.
    @Test func aCookIsSavedUnderTheAccountThatCookedIt() throws {
        let model = try player()
        model.stop()
        let saved = try store.cookLog()
        #expect(saved.map(\.account) == [FakeAuthService.account])
    }

    @Test func aCookSavedWithNobodySignedInHasNoAccountAndIsNeverSent() throws {
        let model = try player(signedIn: false)
        model.stop()
        #expect(try store.cookLog().map(\.account) == [nil])
        #expect(try store.pendingCookEntries(for: CookEntry.fixtureAccount).isEmpty)
    }

    private func player(signedIn: Bool = true) throws -> PlayerModel {
        let dish = try LibraryFixture.shippedOmelette()
        let brief = PlayerBrief(lessonID: dish.id, revision: dish.revision, title: "", swaps: [], ingredients: [])
        let services = AppServices.fake(library: BundledLessonLibrary(), store: store, signedIn: signedIn)
        return PlayerModel(dish: dish, brief: brief, flow: AppFlowModel(services: services))
    }
}
