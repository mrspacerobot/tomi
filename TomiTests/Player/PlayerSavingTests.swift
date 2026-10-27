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
        let model = try player()
        model.stop()
        let saved = try store.pendingCookEntries()
        #expect(saved.count == 1)
        #expect(saved.first?.session.timeZone == TimeZone.current)
    }

    private func player() throws -> PlayerModel {
        let dish = try LibraryFixture.shippedOmelette()
        let brief = PlayerBrief(lessonID: dish.id, revision: dish.revision, title: "", swaps: [], ingredients: [])
        let flow = AppFlowModel(services: .fake(library: BundledLessonLibrary(), store: store))
        return PlayerModel(dish: dish, brief: brief, flow: flow)
    }
}
