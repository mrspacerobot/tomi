import Foundation
import Testing

@testable import Tomi

@Suite struct RefreshAccountSwitchTests {
    @Test(arguments: [200, 400])
    func aLateRefreshNeverReplacesOrDeletesTheNewAccount(status: Int) async throws {
        let fixture = try RefreshSwitchFixture(status: status)
        await #expect(throws: BackendError.notSignedIn) {
            try await fixture.auth.accessToken(for: "cook-a", renewing: true)
        }
        #expect(try fixture.store.load() == fixture.replacement)
    }
}
