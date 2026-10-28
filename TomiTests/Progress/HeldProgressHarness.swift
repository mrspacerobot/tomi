@testable import Tomi

@MainActor
struct HeldProgressHarness {
    let auth: SwitchingAccountAuth
    let store: InMemoryProgressStore
    let api: HeldProgressAPI
    let model: ProgressModel

    init() {
        auth = SwitchingAccountAuth()
        store = InMemoryProgressStore()
        api = HeldProgressAPI()
        model = ProgressModel(store: store, server: ProgressServer(api: api, auth: auth), clock: .phone)
    }
}
