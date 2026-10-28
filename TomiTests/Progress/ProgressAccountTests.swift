import Foundation
import Testing

@testable import Tomi

@MainActor
@Suite struct ProgressAccountTests {
    @Test func switchingAccountsNeverShowsThePreviousCooksSnapshot() async throws {
        let auth = SwitchingAccountAuth()
        let store = InMemoryProgressStore()
        let api = FakeTomiAPI()
        let server = ProgressServer(api: api, auth: auth)
        let model = ProgressModel(store: store, server: server, clock: .phone)
        await model.refresh()
        #expect(model.shown?.snapshot != nil)
        auth.switchTo("cook-b")
        model.reload()
        #expect(model.shown?.snapshot == nil)
    }

    @Test func aLateSnapshotIsNotKeptAfterTheAccountChanges() async throws {
        let harness = HeldProgressHarness()
        var arrivals = harness.api.arrivals.makeAsyncIterator()
        let refresh = Task { await harness.model.refresh() }
        _ = await arrivals.next()
        harness.auth.switchTo("cook-b")
        await harness.api.release()
        await refresh.value
        #expect(try harness.store.progressSnapshot(for: "cook-a") == nil)
        #expect(try harness.store.progressSnapshot(for: "cook-b") == nil)
        #expect(harness.model.shown?.snapshot == nil)
    }
}
