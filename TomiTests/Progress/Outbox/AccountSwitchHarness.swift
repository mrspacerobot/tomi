import Foundation
import TomiCore

@testable import Tomi

@MainActor
struct AccountSwitchHarness {
    let store = InMemoryProgressStore()
    let transport: AccountSwitchTransport
    let uploader: CookEntryUploader

    init() throws {
        let auth = SwitchingAccountAuth()
        transport = AccountSwitchTransport(auth: auth)
        let client = APIClient(baseURL: APIHarness.base, auth: auth, transport: transport)
        try store.add(CookEntry.fixture("eggs", onOctober: 1).cooked(by: "cook-a"))
        let services = OutboxServices(api: URLSessionTomiAPI(client: client), auth: auth, store: store)
        uploader = CookEntryUploader(services, clock: Self.clock)
    }

    private static var clock: UploaderClock {
        UploaderClock(
            now: { .october(27) },
            calendar: { UploaderHarness.calendar },
            sleeper: RecordingSleeper()
        )
    }
}
