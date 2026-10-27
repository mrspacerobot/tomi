/// What the uploader works with: the server it sends to, the sign-in that says whose cooks may go, and the store
/// that holds them.
struct OutboxServices {
    let api: any TomiAPI
    let auth: any AuthService
    let store: any ProgressStore
}

extension OutboxServices {
    init(_ services: AppServices) {
        self.init(api: services.api, auth: services.auth, store: services.store)
    }
}
