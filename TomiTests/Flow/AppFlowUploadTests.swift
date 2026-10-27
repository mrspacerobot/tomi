import Foundation
import Testing
import TomiCore

@testable import Tomi

/// The app sends the outbox by itself once the cook is signed in: on launch and whenever it becomes active again.
@MainActor
@Suite(.timeLimit(.minutes(1))) struct AppFlowUploadTests {
    let store = InMemoryProgressStore()

    func flow(signedIn: Bool) throws -> AppFlowModel {
        try store.add(CookEntry.fixture("eggs", onOctober: 5))
        return AppFlowModel(services: services(signedIn: signedIn))
    }

    func services(signedIn: Bool) -> AppServices {
        let library = BundledLessonLibrary()
        return AppServices(
            api: FakeTomiAPI(library: library),
            auth: FakeAuthService(signedIn: signedIn),
            library: library,
            store: store,
            photos: .fixed(PhotoSource.fakePhoto),
            usesFakeSignInButton: true
        )
    }

    @Test func aLaunchSignedInSendsTheOutbox() async throws {
        let flow = try flow(signedIn: true)
        await flow.start()
        await flow.uploader.waitUntilIdle()
        #expect(try store.pendingCookEntries(for: CookEntry.fixtureAccount).isEmpty)
        #expect(try store.progressSnapshot() != nil)
    }

    @Test func signedOutNothingIsSent() async throws {
        let flow = try flow(signedIn: false)
        await flow.start()
        flow.appBecameActive()
        await flow.uploader.waitUntilIdle()
        #expect(try store.pendingCookEntries(for: CookEntry.fixtureAccount).count == 1)
    }

    @Test func becomingActiveSendsTheOutbox() async throws {
        let flow = try flow(signedIn: true)
        flow.appBecameActive()
        await flow.uploader.waitUntilIdle()
        #expect(try store.pendingCookEntries(for: CookEntry.fixtureAccount).count == 1)
        await flow.start()
        await flow.uploader.waitUntilIdle()
        try store.add(CookEntry.fixture("eggs", onOctober: 6))
        flow.appBecameActive()
        await flow.uploader.waitUntilIdle()
        #expect(try store.pendingCookEntries(for: CookEntry.fixtureAccount).isEmpty)
    }
}
