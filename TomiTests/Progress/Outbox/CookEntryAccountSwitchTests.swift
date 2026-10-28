import Foundation
import Testing
import TomiCore

@testable import Tomi

@MainActor
@Suite struct CookEntryAccountSwitchTests {
    @Test func anAccountSwitchDuring401NeverRetriesTheCookWithAnotherAccount() async throws {
        let harness = try AccountSwitchHarness()
        harness.uploader.upload()
        await harness.uploader.waitUntilIdle()
        #expect(harness.transport.requests.count == 1)
        #expect(try harness.store.pendingCookEntries(for: "cook-a").count == 1)
    }
}
